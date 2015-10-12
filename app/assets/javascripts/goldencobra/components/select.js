var OptionItem = React.createClass({
  displayName: 'OptionItem',
  render: function() {
    return (
      React.createElement('option', { value: this.props.value }, this.props.label)
    );
  }
});

var SelectList = React.createClass({
  displayName: 'SelectList',
  render: function() {
    var jsonOptions = this.props.options;
    var optionNodes = this.props.options[this.getRoot(jsonOptions)].map(function (el) {
      return (
        React.createElement(OptionItem, { value: el.value, label: el.label, key: el.value })
      );
    });

    var emptyOption;

    if (this.props.firstBlank === true) {
      emptyOption = React.createElement('option', { value: '' }, this.props.label);
    }

    return (
      React.createElement('select', {
          className: this.props.className + ' select-list reacted',
          id: this.props.id, style: { width: '80%' },
          value: this.props.value,
          name: this.props.name,
          "data-placeholder": this.props.dataPlaceholder
        },
        emptyOption,
        optionNodes
      )
    );
  },
  getRoot: function(json) {
    for(var prop in json) {
     return prop; // return first found element in json
    }
  }
});
