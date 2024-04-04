getData = reactive({
    print(csvChoice())
    df = ""
    if (userUpload()) {
      df = uploadedCsv()
      return (df)
    } else {
      if (csvChoice() == "Anomaly") {
        df = Anomaly
      } else if (csvChoice() == "MaxCut") {
        df = MaxCut
      } else {
        df = Classification
      }
      return (df)
    }
  })
  
  uploadedCsv = function(){
    csv = read.csv(input$upload$datapath)
  }
  
  getParas = reactive({
    modout = getModout()
    paras = modout$model$param
  })
  
  getObj0Per = reactive({
    df = getData()
    modout = getModout()
    scale = scaleSelected()
    scaleMethod = scaleMethod()
    
    obj = latent_trait_analysis(
      df,
      paras = modout$model$param,
      epsilon = 0,
      scale = scale,
      scale.method = scaleMethod
    )
    obj
  })
  
  getObj5Per = reactive({
    df = getData()
    scale = scaleSelected()
    scaleMethod = scaleMethod()
    modout = getModout()
    obj = latent_trait_analysis(
      df,
      paras = modout$model$param,
      epsilon = 0.02,
      scale = scale,
      scale.method = scaleMethod
    )
  })
  
  getModout = reactive({
    df = getData()
    modout = cirtmodel(df, scale = scaleSelected(), scale.method = scaleMethod())
  })
  
  getModGood = reactive({
    modGood = model_goodness_crm(getModout())
  })
  
  getModEff = reactive({
    modeleff = effectiveness_crm(getModout())
  })