Template.expensesImport.helpers
  activeIfTemplateIs: (tpl) ->
      currentRoute = Router.current()
      if currentRoute and tpl == currentRoute.lookupTemplate() then 'active' else ''

Template.fuelExpenses.onCreated ->
  Template.instance().importing = new ReactiveVar false

Template.fuelExpenses.helpers
  tableSettings: ->
    fields: [
      "Quantity"
      "Fill Date"
      "Fuel Type"
      "Reg No"
      "Amount with VAT"
      { key: "timestamp", label: "Timestamp"}
    ]
  expenses: -> Expenses
  importing: -> Template.instance().importing.get()

Template.fuelExpenses.events
  'change [name="importFile"]': (e, tpl) ->
    tpl.importing.set true
    reader = new FileReader
    name = e.target.files[0].name
    reader.onload = (e) =>
      data = e.target.result
      workbook = XLSX.read data, type: 'binary'
      sheetNames = workbook.SheetNames
      sheetNames.forEach (sheetName) ->
        sheet = workbook.Sheets[sheetName]
        if Object.keys(sheet).length isnt 0
          expenses = XLSX.utils.sheet_to_json sheet
          for expense in expenses
            Expenses.insert expense, (err, res) ->
              console.error err if err
        if reader.readyState = 2
          e.target.value = ""
          tpl.importing.set false

    reader.readAsBinaryString e.target.files[0]
