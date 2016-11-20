Meteor.publish 'calendarEvents', (start, end) -> CalendarEvents.find { 
    $or: [ 
      date: 
        $gte: start
      date: 
      	$lte: end
    ]}