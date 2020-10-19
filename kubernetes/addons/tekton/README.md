# [Tekton](https://github.com/tektoncd/pipeline)

* https://github.com/tektoncd/pipeline/blob/master/docs/install.md
* https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
* https://github.com/tektoncd/pipeline/releases

**dashboard**

* https://github.com/tektoncd/dashboard
* https://github.com/tektoncd/dashboard/releases **tekton-dashboard-release.yaml**

**CI/CD**

* https://blog.csdn.net/shenshouer/article/details/89334956
* https://segmentfault.com/a/1190000020182215

**triggers**

* https://github.com/tektoncd/triggers
* https://github.com/tektoncd/triggers/releases **release.yaml**

**CRD**

**Task：** 顾名思义，task表示一个构建任务，task里可以定义一系列的steps，例如编译代码、构建镜像、推送镜像等，每个step实际由一个Pod执行。

**TaskRun：** task只是定义了一个模版，taskRun才真正代表了一次实际的运行，当然你也可以自己手动创建一个taskRun，taskRun创建出来之后，就会自动触发task描述的构建任务。

**Pipeline：** 一个或多个task、PipelineResource以及各种定义参数的集合。

**PipelineRun：** 类似task和taskRun的关系，pipelineRun也表示某一次实际运行的pipeline，下发一个pipelineRun CRD实例到kubernetes后，同样也会触发一次pipeline的构建。

**组件**

controller 用来监听上述 CRD 的事件，执行 Tekton 的各种 CI/CD 逻辑，webhook 用于校验创建的CRD 资源

webhook 使用了 kubernetes 的 admissionwebhook 机制，所以，在我们 kubectl create 一个taskRun 或者 pipelineRun 时，apiserver 会回调这里部署的 Tekton webhook 服务，用于校验这些CRD 字段等的正确性。

**v1beta1**

* https://github.com/tektoncd/pipeline/blob/master/docs/migrating-v1alpha1-to-v1beta1.md
* `PipelineResources` 废弃

## 部署

```bash
$ kubectl apply -k .
```

## 国内镜像

**ccr.ccs.tencentyun.com/khs1994**
