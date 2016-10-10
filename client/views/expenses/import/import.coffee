Template.expensesImport.helpers
  droppedFiles: -> _.toArray Template.instance().droppedFiles.get()
  dropHandlers: ->
    tpl = Template.instance()
    {
      onDrop: (files) ->
        tpl.droppedFiles.set files
        for file in files
          file.processed = false
          reader = new FileReader
          reader.onload = (e) =>
            data = e.target.result
            workbook = XLSX.read data, type: 'binary'
            sheetNames = workbook.SheetNames
            sheetNames.forEach (sheetName) ->
              sheet = workbook.Sheets[sheetName]
              if Object.keys(sheet).length isnt 0
                expenses = XLSX.utils.sheet_to_json sheet
                tpl.importedExpenses.set expenses
                # for expense in expenses
                #   Expenses.insert expense, (err, res) ->
                #     console.error err if err
              # if reader.readyState = 2
              #   e.target.value = ""
              #   tpl.processing.set false

          reader.readAsBinaryString file
          file.processed = true
    }

Template.expensesImport.onRendered ->
  tpl = Template.instance()
  @$('[data-toggle="confirm-import"]').confirmation(
    onConfirm: ->
      expenses = tpl.importedExpenses.get()
      for expense in expenses
        Expenses.insert expense, (err, res) ->
          console.error err if err
  )

Template.expensesImport.onCreated ->
  Template.instance().droppedFiles = new ReactiveVar []
  Template.instance().processing = new ReactiveVar false
  Template.instance().importedExpenses = new ReactiveVar []

Template.expensesImport.helpers
  tableSettings: ->
    fields: [
      "Quantity"
      "Fill Date"
      "Fuel Type"
      "Reg No"
      "Amount with VAT"
      { key: "timestamp", label: "Timestamp"}
    ]
  expenses: -> Template.instance().importedExpenses.get()
  processed: -> @processed
