Template.sidebar.helpers
    activeCategory: (cat) ->
      if Session.get('activeCategory') == cat
        'active'
      else
        ''
