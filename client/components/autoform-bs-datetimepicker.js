AutoForm.addInputType("datetimepicker", {
  template: "afBootstrapDatetimepicker",
  valueOut: function () {
      return new Date(this.data("DateTimePicker").getDate());
  },
  valueConverters: {
    "string": function (val) {
      return (val instanceof Date) ? AutoForm.Utility.dateToDateStringUTC(val) : val;
    },
    "stringArray": function (val) {
      if (val instanceof Date) {
        return [AutoForm.Utility.dateToDateStringUTC(val)];
      }
      return val;
    },
    "number": function (val) {
      return (val instanceof Date) ? val.getTime() : val;
    },
    "numberArray": function (val) {
      if (val instanceof Date) {
        return [val.getTime()];
      }
      return val;
    },
    "dateArray": function (val) {
      if (val instanceof Date) {
        return [val];
      }
      return val;
    }
  }
});

Template.afBootstrapDatetimepicker.helpers({
    atts: function addFormControlAtts() {
      var atts = _.clone(this.atts);
      // Add bootstrap class
      atts = AutoForm.Utility.addClass(atts, "form-control");
      return atts;
    }
  });

Template.afBootstrapDatetimepicker.rendered = function () {
  var $input = this.$('input');
  var data = this.data;

  console.log(data.atts.datetimePickerOptions);
  if (data.atts.datetimePickerOptions)  {
    $input.datetimepicker(JSON.parse(data.atts.datetimePickerOptions));
  } else {
    $input.datetimepicker({format:Settings.longDateTimeFormat, locale:Settings.locale});
  }
// set and reactively update values
  this.autorun(function () {
    var data = Template.currentData();

    // set field value
    if (data.value instanceof Date) {
      if (data.value) {
        $input.data("DateTimePicker").setDate(data.value);
      } else if (typeof data.value === "string") {
        $input.data("DateTimePicker").setDate(new Date(data.value));
      }
    } else {
      $input.data("DateTimePicker").setDate(new Date());
    }

    // set start date if there's a min in the schema
    if (data.min instanceof Date) {
      $input.data("DateTimePicker").setMinDate(data.min);
    }

    // set end date if there's a max in the schema
    if (data.max instanceof Date) {
      $input.data("DateTimePicker").setMaxDate(data.max);
    }
  });
};

Template.afBootstrapDatetimepicker.destroyed = function () {
  this.$('input').datetimepicker('remove');
};
