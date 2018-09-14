cd $PSScriptRoot

$SwitchName='k8s'
$ISO_PATH="$PSScriptRoot\current\coreos_production_iso_image.iso"

if (!(Test-Path .env)){
  cp .env.example .env
}

Function _init(){
cd current

$items="coreos_production_iso_image.iso","coreos_production_image.bin.bz2", `
  "coreos_production_image.bin.bz2.sig","version.txt"

Foreach ($item in $items)
{
  if(!(Test-Path $item)){
    Write-warning "$item not found, downloding ...

    "

    wsl curl -O http://alpha.release.core-os.net/amd64-usr/current/$item
  }
}

cd ..
}

Function print_help_info(){
  write-host "
CoreOS CLI

Usages:

init       Download CoreOS ISO files
server     Up CoreOS install local server
add-node   create node ignition yaml file [example: add-node 4 ]

cert       Generate Self-Signed Certificates

build      Build Docker Image
push       Push Docker Image
pull       Pull Docker Image

new-vm     New Hyper-V vm [example: new-vm 1 ]
"
}

switch ($args[0])
{
  "init" {
    _init
  }

  "server" {
    # generate cret first
    if (!(Test-Path cert/server-cert.pem)){
      cd ..
      docker-compose up cfssl
      cd coreos
    }
    cd ..
    docker-compose up server
    cd coreos
    break
  }

  "add-node" {
    $node=$args[1]

    if ($node -le 3){
      Write-Error "Please Input >3 number"
      exit
    }

    cp disk/example/ignition-n.template.yaml disk/ignition-${node}.yaml
    wsl sed -i "s#{{n}}#${node}#g" disk/ignition-${node}.yaml
    break
  }

  "cert" {
    cd ..
    docker-compose up cfssl
    cd coreos
    break
  }

  "build" {
    cd ..
    docker-compose -f docker-compose.build.yml build
    cd coreos
    break
  }

  "push" {
    cd ..
    docker-compose push
    cd coreos
    break
  }

  "pull" {
    cd ..
    docker-compose pull
    cd coreos
  }

  "new-vm" {
    $VMName = $args[1]

    if($VMName.length -eq 0){
      Write-Error "
Please input node name [coreos1]
      "
      exit
    }

    Get-NetAdapter "vEthernet ($SwitchName)" -ErrorAction "SilentlyContinue"

    if (!($?)){
      New-VMSwitch -Name $SwitchName -SwitchType Internal

      New-NetIPAddress -IPAddress 192.168.57.1 -PrefixLength 24 -InterfaceIndex 24

      New-NetNat –Name LocalNAT –InternalIPInterfaceAddressPrefix 192.168.57.1/24

      Get-NetAdapter "vEthernet ($SwitchName)" | New-NetIPAddress -IPAddress 192.168.57.1 -AddressFamily IPv4 -PrefixLength 24
    }

    $VM = @{
    Name = $VMName
    MemoryStartupBytes = 2GB
    Generation = 1
    NewVHDPath = "C:\Hyper-V\$VMName\$VMName.vhdx"
    NewVHDSizeBytes = 53687091200
    SwitchName = $SwitchName
    }

    New-VM @VM

    Add-VMDvdDrive -VMName $VMName -Path $ISO_PATH

  }

  Default {
    print_help_info
  }
}
