Template.expensesImport.onCreated ->
  Template.instance().importing = new ReactiveVar false

Template.expensesImport.helpers
  tableSettings: ->
  expenses: ->
    Expenses
  importing: ->
    Template.instance().importing.get()

Template.expensesImport.events
  'change [name="importFile"]': (e, tpl) ->
    # Template.instance().importing.set true
    reader = new FileReader
    name = e.target.files[0].name
    reader.onload = (e) ->
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
      # Template.instance().importing.set false

    reader.readAsBinaryString e.target.files[0]
    e.target.value = ""
