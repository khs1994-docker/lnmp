Function _cleanup($items){
  Foreach ($item in $items)
  {
    if(test-path $item){
      remove-item -r -force $item
    }
  }
}
