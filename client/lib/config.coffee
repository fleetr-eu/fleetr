Blaze._allowJavascriptUrls()

@loadGmaps = (ver) =>
  unless google
    ver = ver || '3.18'
    $.getScript "https://maps.googleapis.com/maps/api/js?v=#{ver}&key=AIzaSyCO_NvDDs6yqtWOiQS4ZFHWJquK_jjh2pM&sensor=true&libraries=places,geometry"
    # console.log google
    @google = window.google

loadGmaps()
