Meteor.startup ->
  @Autocomplete =
    init: (map) ->
      input = document.getElementById("pac-input")
      pacSearch = document.getElementById("pac-search")
      map.controls[google.maps.ControlPosition.TOP_LEFT].push pacSearch

      autocomplete = new google.maps.places.Autocomplete(input)
      autocomplete.bindTo "bounds", map
      infowindow = new google.maps.InfoWindow()
      searchMarker = new google.maps.Marker
        map: map
        anchorPoint: new google.maps.Point(0, -29)

      google.maps.event.addListener autocomplete, "place_changed", ->
        infowindow.close()
        searchMarker.setVisible false
        place = autocomplete.getPlace()
        return  unless place.geometry

        # If the place has a geometry, then present it on a map.
        if place.geometry.viewport
          map.fitBounds place.geometry.viewport
        else
          map.setCenter place.geometry.location
          map.setZoom 17 # Why 17? Because it looks good.

        searchMarker.setIcon (
          url: place.icon
          size: new google.maps.Size(71, 71)
          origin: new google.maps.Point(0, 0)
          anchor: new google.maps.Point(17, 34)
          scaledSize: new google.maps.Size(35, 35)
        )
        searchMarker.setPosition place.geometry.location
        searchMarker.setVisible true
        address = ""
        if place.address_components
          address = [
            place.address_components[0] and place.address_components[0].short_name or ""
            place.address_components[1] and place.address_components[1].short_name or ""
            place.address_components[2] and place.address_components[2].short_name or ""
          ].join(" ")
        infowindow.setContent "<div><strong>" + place.name + "</strong><br>" + address
        infowindow.open map, searchMarker
