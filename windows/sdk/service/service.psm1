# https://github.com/microsoft/SDN/blob/master/Kubernetes/windows/helper.v2.psm1

function CreateSCMService()
{
    param
    (
        [parameter(Mandatory=$true)] [string] $ServiceName,
        [parameter(Mandatory=$true)] [string[]] $CommandLine,
        [parameter(Mandatory=$true)] [string] $LogFile,
        [parameter(Mandatory=$false)] [Hashtable] $EnvVaribles = $null
    )
    $Binary = $CommandLine[0].Replace("\", "\\");
    $Arguments = ($CommandLine | Select -Skip 1).Replace("\", "\\").Replace('"', '\"')
    $SvcBinary = "$Global:BaseDir\${ServiceName}Svc.exe"
    $LogFile = $LogFile.Replace("\", "\\")

    $envSrc = "";
    if ($EnvVaribles)
    {
        foreach ($key in $EnvVaribles.Keys)
        {
            $value = $EnvVaribles[$key];
            $envSrc += @"
            m_process.StartInfo.EnvironmentVariables["$key"] = "$value";
"@
        }
    }

    Write-Warning "Create a SCMService Binary for [$ServiceName] [$CommandLine] => [$SvcBinary]"
    # reference: https://msdn.microsoft.com/en-us/magazine/mt703436.aspx
    $svcSource = @"
        using System;
        using System.IO;
        using System.ServiceProcess;
        using System.Diagnostics;
        using System.Runtime.InteropServices;
        using System.ComponentModel;
        public enum ServiceType : int {
            SERVICE_WIN32_OWN_PROCESS = 0x00000010,
            SERVICE_WIN32_SHARE_PROCESS = 0x00000020,
        };

        public enum ServiceState : int {
            SERVICE_STOPPED = 0x00000001,
            SERVICE_START_PENDING = 0x00000002,
            SERVICE_STOP_PENDING = 0x00000003,
            SERVICE_RUNNING = 0x00000004,
            SERVICE_CONTINUE_PENDING = 0x00000005,
            SERVICE_PAUSE_PENDING = 0x00000006,
            SERVICE_PAUSED = 0x00000007,
        };

        [StructLayout(LayoutKind.Sequential)]
        public struct ServiceStatus {
            public ServiceType dwServiceType;
            public ServiceState dwCurrentState;
            public int dwControlsAccepted;
            public int dwWin32ExitCode;
            public int dwServiceSpecificExitCode;
            public int dwCheckPoint;
            public int dwWaitHint;
        };
        public class ScmService_$ServiceName : ServiceBase {
            private ServiceStatus m_serviceStatus;
            private Process m_process;
            private StreamWriter m_writer = null;
            public ScmService_$ServiceName() {
                ServiceName = "$ServiceName";
                CanStop = true;
                CanPauseAndContinue = false;

                m_writer = new StreamWriter("$LogFile");
                Console.SetOut(m_writer);
                Console.WriteLine("$Binary $ServiceName()");
            }
            ~ScmService_$ServiceName() {
                if (m_writer != null) m_writer.Dispose();
            }
            [DllImport("advapi32.dll", SetLastError=true)]
            private static extern bool SetServiceStatus(IntPtr handle, ref ServiceStatus serviceStatus);
            protected override void OnStart(string [] args) {
                EventLog.WriteEntry(ServiceName, "OnStart $ServiceName - $Binary $Arguments");
                m_serviceStatus.dwServiceType = ServiceType.SERVICE_WIN32_OWN_PROCESS; // Own Process
                m_serviceStatus.dwCurrentState = ServiceState.SERVICE_START_PENDING;
                m_serviceStatus.dwWin32ExitCode = 0;
                m_serviceStatus.dwWaitHint = 2000;
                SetServiceStatus(ServiceHandle, ref m_serviceStatus);
                try
                {
                    m_process = new Process();
                    m_process.StartInfo.UseShellExecute = false;
                    m_process.StartInfo.RedirectStandardOutput = true;
                    m_process.StartInfo.RedirectStandardError = true;
                    m_process.StartInfo.FileName = "$Binary";
                    m_process.StartInfo.Arguments = "$Arguments";
                    m_process.EnableRaisingEvents = true;
                    m_process.OutputDataReceived  += new DataReceivedEventHandler((s, e) => { Console.WriteLine(e.Data); });
                    m_process.ErrorDataReceived += new DataReceivedEventHandler((s, e) => { Console.WriteLine(e.Data); });
                    m_process.Exited += new EventHandler((s, e) => {
                        Console.WriteLine("$Binary exited unexpectedly " + m_process.ExitCode);
                        if (m_writer != null) m_writer.Flush();
                        m_serviceStatus.dwCurrentState = ServiceState.SERVICE_STOPPED;
                        SetServiceStatus(ServiceHandle, ref m_serviceStatus);
                    });
                    $envSrc;
                    m_process.Start();
                    m_process.BeginOutputReadLine();
                    m_process.BeginErrorReadLine();
                    m_serviceStatus.dwCurrentState = ServiceState.SERVICE_RUNNING;
                    Console.WriteLine("OnStart - Successfully started the service ");
                }
                catch (Exception e)
                {
                    Console.WriteLine("OnStart - Failed to start the service : " + e.Message);
                    m_serviceStatus.dwCurrentState = ServiceState.SERVICE_STOPPED;
                }
                finally
                {
                    SetServiceStatus(ServiceHandle, ref m_serviceStatus);
                    if (m_writer != null) m_writer.Flush();
                }
            }
            protected override void OnStop() {
                Console.WriteLine("OnStop $ServiceName");
                try
                {
                    m_serviceStatus.dwCurrentState = ServiceState.SERVICE_STOPPED;
                    if (m_process != null)
                    {
                        m_process.Kill();
                        m_process.WaitForExit();
                        m_process.Close();
                        m_process.Dispose();
                        m_process = null;
                    }
                    Console.WriteLine("OnStop - Successfully stopped the service ");
                }
                catch (Exception e)
                {
                    Console.WriteLine("OnStop - Failed to stop the service : " + e.Message);
                    m_serviceStatus.dwCurrentState = ServiceState.SERVICE_RUNNING;
                }
                finally
                {
                    SetServiceStatus(ServiceHandle, ref m_serviceStatus);
                    if (m_writer != null) m_writer.Flush();
                }
            }
            public static void Main() {
                System.ServiceProcess.ServiceBase.Run(new ScmService_$ServiceName());
            }
        }
"@

    Add-Type -TypeDefinition $svcSource -Language CSharp `
        -OutputAssembly $SvcBinary -OutputType ConsoleApplication   `
        -ReferencedAssemblies "System.ServiceProcess" -Debug:$false

    return $SvcBinary
}

function RemoveService()
{
    param
    (
        [parameter(Mandatory=$true)] [string] $ServiceName
    )

    $src = Get-Service -Name $ServiceName  -ErrorAction SilentlyContinue

    if ($src) {
        Stop-Service $src
        sc.exe delete $src;

        $wsrv = gwmi win32_service | ? Name -eq $ServiceName

        # Remove the temp svc binary
    }
}

function CreateService()
{
    param
    (
        [parameter(Mandatory=$true)] [string] $ServiceName,
        [parameter(Mandatory=$true)] [string[]] $CommandLine,
        [parameter(Mandatory=$true)] [string] $LogFile,
        [parameter(Mandatory=$false)] [Hashtable] $EnvVaribles = $null
    )

    $binary = CreateSCMService -ServiceName $ServiceName -CommandLine $CommandLine -LogFile $LogFile -EnvVaribles $EnvVaribles

    New-Service -name $ServiceName -binaryPathName $binary `
        -displayName $ServiceName -startupType Manual    `
        -Description "$ServiceName Service" | out-null

    Write-Host @"
++++++++++++++++++++++++++++++++
Successfully created the service
++++++++++++++++++++++++++++++++
Service [$ServiceName]
Cmdline [$binary]
Env     [$($EnvVaribles | ConvertTo-Json -Depth 10)]
Log     [$LogFile]
++++++++++++++++++++++++++++++++
"@
}

Export-ModuleMember CreateService
Export-ModuleMember RemoveService
