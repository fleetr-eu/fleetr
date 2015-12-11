Template.expense.events
  "blur input[name='totalVATIncluded']" : (e, t) ->
    totalVATIncluded = Number(e.target.value)
    if totalVATIncluded
      total = Number((Number(totalVATIncluded / 1.20)).toFixed(2))
      vat = Number((Number(totalVATIncluded - total)).toFixed(2))
      if not t.$("input[name='total']").val() then t.$("input[name='total']").val(total)
      if not t.$("input[name='vat']").val() then t.$("input[name='vat']").val(vat)
  "blur input[name='total']" : (e, t) ->
    total = Number(e.target.value)
    if total
      totalVATIncluded =  Number((Number(total + 0.2 * total)).toFixed(2))
      vat = Number((Number(totalVATIncluded - total)).toFixed(2))
      if not t.$("input[name='totalVATIncluded']").val() then t.$("input[name='totalVATIncluded']").val(totalVATIncluded)
      if not t.$("input[name='vat']").val() then t.$("input[name='vat']").val(vat) 