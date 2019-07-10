Function _cleanup(){
  Foreach ($item in $args)
  {
    if(test-path $item){
      remove-item -r -force $item
    }
  }
}
