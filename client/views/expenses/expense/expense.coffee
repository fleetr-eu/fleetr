Template.expense.events
  "blur input[name='totalVATIncluded']" : (e, t) ->
    totalVATIncluded = e.target.value
    console.log totalVATIncluded
    discount = t.$("input[name='discount']").val()
    total = totalVATIncluded / (1+(20/100)) - discount
    console.log total
    #vat = $("input[name='vat']").val()
    #discount = $("input[name='discount']").val()
