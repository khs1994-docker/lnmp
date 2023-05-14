#
# @link https://github.com/evanlucas/fish-kubectl-completions
#

set __kubectl_commands \
  get                  \
  set                  \
  describe             \
  create               \
  replace              \
  patch                \
  delete               \
  edit                 \
  apply                \
  namespace            \
  logs                 \
  rolling-update       \
  scale                \
  cordon               \
  drain                \
  uncordon             \
  attach               \
  exec                 \
  port-forward         \
  proxy                \
  run                  \
  expose               \
  autoscale            \
  rollout              \
  label                \
  annotate             \
  taint                \
  config               \
  cluster-info         \
  api-versions         \
  version              \
  explain              \
  convert              \
  completion

set __kubectl_resources          \
  all                            \
  certificatesigningrequests csr \
  clusterrolebindings            \
  clusterroles                   \
  clusters                       \
  componentstatuses cs           \
  configmaps configmap cm        \
  controllerrevisions            \
  cronjobs                       \
  customresourcedefinition crd   \
  daemonsets ds                  \
  deployments deployment deploy  \
  endpoints ep                   \
  events ev                      \
  horizontalpodautoscalers hpa   \
  ingresses ingress ing          \
  jobs                           \
  limitranges limits             \
  namespaces namespace ns        \
  networkpolicies netpol         \
  nodes node no                  \
  persistentvolumeclaims pvc     \
  persistentvolumes pv           \
  poddisruptionbudgets pdb       \
  podpreset                      \
  pods pod po                    \
  podsecuritypolicies psp        \
  podtemplates                   \
  replicasets rs                 \
  replicationcontrollers rc      \
  resourcequotas quota           \
  rolebindings                   \
  roles                          \
  secrets secret                 \
  serviceaccounts sa             \
  services service svc           \
  statefulsets sts               \
  storageclass storageclasses sc

set __kubectl_config_subcommands \
  current-context \
  delete-cluster  \
  delete-context  \
  get-clusters    \
  get-contexts    \
  rename-context  \
  set             \
  set-cluster     \
  set-context     \
  set-credentials \
  unset           \
  use-context     \
  view

function __kubectl_subcommands -a cmd
  switch $cmd
    case 'rollout'
      echo history\t'View rollout history'
      echo pause\t'Mark the provided resource as paused'
      echo resume\t'Resume a paused resource'
      echo status\t'Show the status of the rollout'
      echo undo\t'Undo a previous rollout'
  end
end

set __kubectl_rollout_subcommands (__kubectl_subcommands rollout | string replace -r '\t.*$' '')

set -q FISH_KUBECTL_COMPLETION_TIMEOUT; or set FISH_KUBECTL_COMPLETION_TIMEOUT 5s
set __k8s_timeout "--request-timeout=$FISH_KUBECTL_COMPLETION_TIMEOUT"
set __fish_kubectl_subresource_commands get describe delete edit label explain

set __kubectl_all_namespaces_flags "--all-namespaces" "--all-namespaces=true"

function __fish_kubectl
  command kubectl $__k8s_timeout $argv
end

function __fish_kubectl_needs_command -d 'Test if kubectl has yet to be given the subcommand'
  for i in (commandline -opc)
    if contains -- $i $__kubectl_commands
      echo "$i"
      return 1
    end
  end
  return 0
end

function __fish_kubectl_needs_resource -d 'Test if kubectl has yet to be given the subcommand resource'
  set -l resources (__fish_print_resource_types)
  for i in (commandline -opc)
    if contains -- $i $resources
      return 1
    end
  end
  return 0
end


function __fish_kubectl_using_command
  set -l cmd (__fish_kubectl_needs_command)
  test -z "$cmd"
  and return 1

  contains -- $cmd $argv
  and echo "$cmd"
  and return 0

  return 1
end

function __fish_kubectl_using_resource
  set -l cmd (__fish_kubectl_needs_resource)
  test -z "$cmd"
  and return 1

  contains -- $cmd $argv
  and echo "$cmd"
  and return 0

  return 1
end

function __fish_kubectl_get_namespace -d 'Gets the namespace for the current command'
  set -l cmd (commandline -opc)
  if [ (count $cmd) -eq 0 ]
    echo ""
    return 0
  else
    set -l foundNamespace 0
    for c in $cmd
      test $foundNamespace -eq 1
      and echo "$c"
      and return 0
      if contains -- $c "--namespace" "-n"
        set foundNamespace 1
      end
    end

    return 1
  end
end

function __fish_kubectl_all_namespaces -d 'Was --all-namespaces passed'
  for i in (commandline -opc)
    if contains -- $i $__kubectl_all_namespaces_flags
      echo 1
      return 1
    end
  end
  echo 0
  return 0
end

function __fish_kubectl_print_current_resources -d 'Prints current resources'
  set -l found 0
  # There is probably a better way to do this...
  # found === 1 means that we have not yet found the crd type
  # found === 2 means that we have not yet found the crd name, but have found the type
  set -l current_resource
  set -l crd_types (__fish_kubectl_get_crds)
  for i in (commandline -opc)
    if test $found -eq 0
      if contains -- $i $__fish_kubectl_subresource_commands
        set found 1
      end
    end

    if test $found -eq 1
      if contains -- $i $crd_types
        set -l out (__fish_print_resource $i)
        for item in $out
          echo "$item"
        end
        return 0
      end
    end
  end
end

function __fish_print_resource -d 'Print a list of resources' -a resource
  set -l all_ns (__fish_kubectl_all_namespaces)
  test $all_ns -eq 1
  and __fish_kubectl get "$resource" -o name --all-namespaces \
    | string replace -r '(.*)/' ''
  and return

  set -l namespace (__fish_kubectl_get_namespace)
  test -z "$namespace"
  and __fish_kubectl get "$resource" -o name \
    | string replace -r '(.*)/' ''
  and return

  __fish_kubectl --namespace "$namespace" get "$resource" -o name \
    | string replace -r '(.*)/' ''
end

function __fish_print_resource_types
  for r in $__kubectl_resources
    echo $r
  end

  set -l crds (__fish_kubectl_get_crds)

  for r in $crds
    echo $r
  end
end

function __fish_kubectl_get_subcommand
  set -l cmd (commandline -poc)
  set -e cmd[1]
  for i in $cmd
    if contains -- $i $argv
      echo "$i"
      return 0
    end
  end
  return 1
end

function __fish_kubectl_get_containers_for_pod -a pod
  __fish_kubectl get pods "$pod" -o 'jsonpath={.spec.containers[*].name}'
end

function __fish_kubectl_get_crds
  __fish_kubectl get crd -o jsonpath='{range .items[*]}{.spec.names.plural}{"\n"}{.spec.names.singular}{"\n"}{end}'
end

function __fish_kubectl_get_crd_resources -a crd
  __fish_kubectl get "$crd" -o jsonpath='{.items[*].metadata.name}'
end

# deployments, daemonsets, and statefulsets
function __fish_kubectl_get_rollout_resources
  set -l jsonpath '{range .items[*]}{.spec.template.spec.containers[*].name}{"\n"}{end}'
  set -l deploys (__fish_kubectl get deploy -o jsonpath=$jsonpath)
  set -l daemonsets (__fish_kubectl get daemonsets -o jsonpath=$jsonpath)
  set -l statefulsets (__fish_kubectl get statefulsets -o jsonpath=$jsonpath)
  for i in $deploys
    echo "deploy/$i"
    echo "deployment/$i"
    echo "deployments/$i"
  end
  for i in $daemonsets
    echo "daemonset/$i"
    echo "daemonsets/$i"
    echo "ds/$i"
  end
  for i in $statefulsets
    echo "statefulset/$i"
    echo "statefulsets/$i"
    echo "sts/$i"
  end
end

complete -c kubectl -f -n '__fish_kubectl_needs_command' -a get -d "Display one or many resources"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a describe -d "Show details of a specific resource or group of resources"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a delete -d 'Delete resources by filenames, stdin, resources and names, or by resources and label selector.'
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a edit -d "Edit a resource on the server"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a label -d "Update the labels on a resource"

for subcmd in $__fish_kubectl_subresource_commands
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and not __fish_seen_subcommand_from (__fish_print_resource_types)" -a '(__fish_print_resource_types)' -d 'Resource'
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from all" -a '(__fish_print_resource all)' -d 'All'
  for r in certificatesigningrequests csr
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource certificatesigningrequests)' -d 'Certificate Signing Requests'
  end
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from clusterrolebindings" -a '(__fish_print_resource clusterrolebindings)' -d 'Cluster Role Bindings'
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from clusterroles" -a '(__fish_print_resource clusterroles)' -d 'Cluster Roles'
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from clusters" -a '(__fish_print_resource clusters)' -d 'Clusters'
  for r in componentstatuses cs
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource componentstatuses)' -d 'Component Statuses'
  end
  for r in configmaps configmap cm
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource configmaps)' -d 'Config Map'
  end
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from controllerrevisions" -a '(__fish_print_resource controllerrevisions)' -d 'Controller Revision'
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from cronjobs" -a '(__fish_print_resource cronjobs)' -d 'Cron Jobs'
  for r in customresourcedefinition crd
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource customresourcedefinition)' -d 'Custom Resource Definition'
  end
  for r in daemonsets ds
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource daemonsets)' -d 'Daemon set'
  end
  for r in deployments deployment deploy
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource deployments)' -d 'Deployment'
  end
  for r in endpoints ep
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource endpoints)' -d 'Endpoint'
  end
  for r in events ev
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource events)' -d 'Event'
  end
  for r in horizontalpodautoscalers hpa
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource horizontalpodautoscalers)' -d 'Horizontal pod auto scalers'
  end
  for r in ingresses ingress ing
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource ingresses)' -d 'Ingress'
  end
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from jobs" -a '(__fish_print_resource jobs)' -d 'Job'
  for r in limitranges limits
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource limitranges)' -d 'LimitRange'
  end
  for r in namespaces namespace ns
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource namespaces)' -d 'Namespace'
  end
  for r in networkpolicies netpol
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource networkpolicies)' -d 'Network Policy'
  end
  for r in nodes node no
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource nodes)' -d 'Node'
  end
  for r in persistentvolumeclaims pvc
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource persistentvolumeclaims)' -d 'Persistent Volume Claim'
  end
  for r in persistentvolumes pv
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource persistentvolumes)' -d 'Persistent Volume'
  end
  for r in poddisruptionbudgets pdb
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource poddisruptionbudgets)' -d 'Pod Disruption Budget'
  end
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from podpreset" -a '(__fish_print_resource podpreset)' -d 'Pod Preset'
  for r in pods pod po
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource pods)' -d 'Pod'
  end
  for r in podsecuritypolicies psp
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource podsecuritypolicies)' -d 'Pod Security Policy'
  end
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from podtemplates" -a '(__fish_print_resource podtemplates)' -d 'Pod Template'
  for r in replicasets rs
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource replicasets)' -d 'Replica Set'
  end
  for r in replicationcontrollers rc
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource replicationcontrollers)' -d 'Replication Controller'
  end
  for r in resourcequotas quota
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource resourcequotas)' -d 'Resource Quota'
  end
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from rolebindings" -a '(__fish_print_resource rolebindings)' -d 'Role Binding'
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from roles" -a '(__fish_print_resource roles)' -d 'Role'
  for r in secrets secret
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource secrets)' -d 'Secret'
  end
  for r in serviceaccounts sa
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource serviceaccounts)' -d 'Service Account'
  end
  for r in services service svc
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource services)' -d 'Service'
  end
  for r in statefulsets sts
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource statefulsets)' -d 'Stateful Set'
  end
  for r in storageclass storageclasses sc
    complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from $r" -a '(__fish_print_resource storageclasses)' -d 'Storage Class'
  end
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from resources" -a '(__fish_print_resource resources)' -d 'Resource'
  complete -c kubectl -f -n "__fish_kubectl_using_command $subcmd; and __fish_seen_subcommand_from (__fish_kubectl_get_crds)" -a '(__fish_kubectl_print_current_resources)' -d 'CRD'
end

complete -c kubectl -f -n '__fish_kubectl_needs_command' -a set -d "Set specific features on objects"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a create -d "Create a resource by filename or stdin"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a replace -d "Replace a resource by filename or stdin."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a patch -d "Update field(s) of a resource using strategic merge patch."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a apply -d "Apply a configuration to a resource by filename or stdin"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a namespace -d "SUPERSEDED: Set and view the current Kubernetes namespace"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a rolling-update -d "Perform a rolling update of the given ReplicationController."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a scale -d "Set a new size for a Deployment, ReplicaSet, Replication Controller, or Job."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a cordon -d "Mark node as unschedulable"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a drain -d "Drain node in preparation for maintenance"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a uncordon -d "Mark node as schedulable"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a attach -d "Attach to a running container."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a exec -d "Execute a command in a container."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a proxy -d "Run a proxy to the Kubernetes API server"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a run -d "Run a particular image on the cluster."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a expose -d "Take a replication controller, service, deployment or pod and expose it as a new Kubernetes Service"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a autoscale -d "Auto-scale a Deployment, ReplicaSet, or ReplicationController"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a annotate -d "Update the annotations on a resource"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a taint -d "Update the taints on one or more nodes"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a config -d "config modifies kubeconfig files"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a cluster-info -d "Display cluster info"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a api-versions -d "Print the supported API versions on the server, in the form of \"group/version\"."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a version -d "Print the client and server version information."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a explain -d "Documentation of resources."
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a convert -d "Convert config files between different API versions"
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a completion -d "Output shell completion code for the given shell (bash or zsh)"

# logs
for subcmd in log logs
  complete -c kubectl -f -n '__fish_kubectl_needs_command' -a $subcmd -d 'Print the logs for a container in a pod.'
  complete -c kubectl -A -f -n "__fish_seen_subcommand_from $subcmd" -s f -l follow -d 'Follow log output'
  complete -c kubectl -A -f -n "__fish_seen_subcommand_from $subcmd" -s l -l selector -d 'Selector (label query) to filter on'
  complete -c kubectl -A -f -n "__fish_seen_subcommand_from $subcmd" -s p -l previous -d 'Previous instance'
  complete -c kubectl -A -f -n "__fish_seen_subcommand_from $subcmd" -a '(__fish_print_resource pods)' -d "Pod"
end

# exec
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a exec -d 'Execute a command in a container.'
complete -c kubectl -A -f -n '__fish_seen_subcommand_from exec' -a '(__fish_print_resource pods)' -d "Pod"

# port-forward
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a port-forward -d "Forward one or more local ports to a pod."
complete -c kubectl -A -f -n '__fish_seen_subcommand_from port-forward' -a '(__fish_print_resource pods)' -d "Pod"

# rollout
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a rollout -d "Manage rollout of a resource"
complete -c kubectl -A -f -n '__fish_seen_subcommand_from rollout; and not __fish_seen_subcommand_from $__kubectl_rollout_subcommands' -a '(__kubectl_subcommands rollout)'
complete -c kubectl -f -n '__fish_kubectl_using_command rollout; and __fish_seen_subcommand_from $__kubectl_rollout_subcommands' -a '(__fish_kubectl_get_rollout_resources)'

# version
complete -c kubectl -f -n '__fish_kubectl_needs_command' -a version -d 'Print the client and server version information for the current context'
# -c is deprecated, so do not include it.
complete -c kubectl -A -f -n '__fish_seen_subcommand_from version' -l client -d 'Client version only (no server required)'
complete -c kubectl -A -f -n '__fish_seen_subcommand_from version' -s o -l output -a 'yaml json' -d 'Specify output format'
complete -c kubectl -A -f -n '__fish_seen_subcommand_from version' -l short -a 'true false' -d 'Print just the version number'

# config
complete -c kubectl -f -n "__fish_kubectl_using_command config; and not __fish_seen_subcommand_from $__kubectl_config_subcommands" -a '$__kubectl_config_subcommands' -d 'kubectl config subcommand'
complete -c kubectl -f -n '__fish_kubectl_using_command config; and __fish_seen_subcommand_from use-context delete-context' -a '(kubectl config get-contexts -o name)'
