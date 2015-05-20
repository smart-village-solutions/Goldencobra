var NavigationMenu = React.createClass({displayName: 'NavigationMenu',
  menuUrl: function () {
    var methods = this.props.methods.length ? '&methods=' + this.props.methods + ',css_class' : 'css_class';
    var depth = this.props.depth.length ? '&depth=' + this.props.depth : '';
    return '/api/v2/navigation_menus.json?id=' + this.props.menuId + methods + depth;
  },
  loadMenuFromServer: function () {
    $.ajax({
      url: this.menuUrl(),
      dataType: 'json',
      success: function (data) {
        this.setState({data: data});
      }.bind(this),
      error: function (xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function () {
    return {data: []};
  },
  componentDidMount: function () {
    this.loadMenuFromServer();
  },
  render: function () {
    return (
      React.createElement(NavigationList, {data: this.state.data, id: this.props.id, className: 'navigation'})
    );
  }
});

var NavigationList = React.createClass({displayName: 'NavigationList',
  render: function () {
    var navigationNodes = this.props.data.map(function (navEntry) {
      if (navEntry.css_class.indexOf('hidden') == -1) {
        return (
          React.createElement(NavigationListItem, {
            id: navEntry.id,
            key: navEntry.id,
            children: navEntry.children,
            title: navEntry.title,
            target: navEntry.target,
            description: navEntry.liquid_description,
            css_class: navEntry.css_class
          })
        );
      }
    });
    return (
      React.createElement('ul', {
          className: this.props.className,
          id: this.props.id
        },
        navigationNodes
      )
    );
  }
});

var NavigationListItem = React.createClass({displayName: 'ListItem',
  getInitialState: function () {
    return {data: []};
  },
  render: function () {
    var depth;
    if (this.props.depth !== undefined) {
      depth = this.props.depth;
    } else {
      depth = 1;
    }

    var classNames = this.props.css_class;
    var target = this.props.target;

    if (this.props.children.length) {
      classNames = 'has_children';
      target = '#';
    }

    var imageWrapper;
    if (this.props.image !== undefined) {
      imageWrapper = React.createElement('a', {href: target, className: 'navigtion_link_imgage_wrapper'},
        React.createElement('img', {src: 'http://placekitten.com/100/100', alt: 'alt-text'})
      );
    }

    var descriptionTitle;
    if (this.props.descriptionTitle !== undefined) {
      descriptionTitle = React.createElement('a', {
        href: target,
        className: 'navigtion_link_description_title'
      }, this.props.title);
    }

    var linkDescription;
    if (this.props.linkDescription !== undefined) {
      linkDescription = React.createElement('div', {
        className: 'navigtion_link_description'
      }, this.props.description);
    }

    var callToAction;
    if (this.props.callToAction !== undefined) {
      callToAction = React.createElement('a', {
        href: target,
        className: 'navigtion_link_call_to_action_name'
      }, 'call-to-action');
    }

    var showChildren;
    if (this.props.children.length) {
      depth += 1;
      showChildren = React.createElement(NavigationList, {
        data: this.props.children,
        className: 'level_' + depth + ' children_' + this.props.children.length,
        depth: depth});
    }

    return (
      React.createElement('li', {className: classNames, 'data-id': this.props.id},
        React.createElement('a', {href: target}, this.props.title),
        imageWrapper,
        descriptionTitle,
        linkDescription,
        callToAction,
        showChildren
      )
    );
  }
});
