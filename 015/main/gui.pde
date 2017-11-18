void setupGUI(){
  controlP5 = new ControlP5(this);
  controlP5.setColorActive(color(127,127,127));
  controlP5.setColorBackground(color(200));
  controlP5.setColorForeground(color(50));
  controlP5.setColorCaptionLabel(color(50));
  controlP5.setColorValueLabel(color(255));

  ControlGroup ctrl = controlP5.addGroup("CTRL",15,25,45);
  ctrl.setColorLabel(color(0));
  ctrl.close();

  ArrayList<Slider> sliders = new ArrayList<Slider>();

  int left = 0;
  int top = 5;
  int len = 300;

  int idx = 0;
  int offset = 0;

  sliders.add(controlP5.addSlider("count",1,20000,left,top+offset+0,len,15));
  offset += 30;
  sliders.add(controlP5.addSlider("noise",0,1000,left,top+offset+0,len,15));
  sliders.add(controlP5.addSlider("noiseScale",0,1000,left,top+offset+20,len,15));
  sliders.add(controlP5.addSlider("noiseStrength",0,100,left,top+offset+40,len,15));
  sliders.add(controlP5.addSlider("multiplier",-0.01,0.05,left,top+offset+60,len,15));
  offset += 90;
  sliders.add(controlP5.addSlider("strokeWidth",0,10,left,top+offset+0,len,15));
  offset += 50;
  sliders.add(controlP5.addSlider("strokeAlpha",0,255,left,top+offset+0,len,15));
  sliders.add(controlP5.addSlider("overlayAlpha",0,255,left,top+offset+20,len,15));

  for (Slider slider : sliders) {
    slider.setGroup(ctrl);
    slider.getCaptionLabel().toUpperCase(true);
    slider.getCaptionLabel().getStyle().padding(4,3,3,3);
    slider.getCaptionLabel().getStyle().marginTop = -4;
    slider.getCaptionLabel().getStyle().marginLeft = 0;
    slider.getCaptionLabel().getStyle().marginRight = -14;
    slider.getCaptionLabel().setColorBackground(255);
  }
}

void drawGUI(){
  hint(ENABLE_DEPTH_TEST);
  controlP5.show();
  controlP5.draw();
  hint(DISABLE_DEPTH_TEST);
}
