var NavigationMenu = React.createClass({displayName: 'NavigationMenu',
  menuUrl: function () {
    var methods = '&methods=css_class' + (this.props.methods.length ? ',' + this.props.methods : '');
    var depth = this.props.depth.length ? '&depth=' + this.props.depth : '';
    var filterClasses = this.props.filterClasses.length ? '&filter_classes=' + this.props.filterClasses : '';
    var offset = this.props.offset.length ? '&offset=' + this.props.offset : '';
    return '/api/v2/navigation_menus.json?id=' + this.props.menuId + methods + depth + filterClasses + offset;
  },
  loadMenuFromServer: function () {
    $.ajax({
      url: this.menuUrl(),
      dataType: 'json',
      success: function (data) {
        if (App !== undefined && App.navigationMenuHandler !== undefined) {
          this.setState({ data: App.navigationMenuHandler.handleMenuData(data)});
        } else {
          this.setState({data: data});
        }
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
      return (
        React.createElement(NavigationListItem, {
          id: navEntry.id,
          key: navEntry.id,
          children: navEntry.children,
          title: navEntry.title,
          target: navEntry.target,
          linkDescription: navEntry.liquid_description,
          css_class: navEntry.css_class,
          image: navEntry.navigation_image,
          descriptionTitle: navEntry.description_title,
          callToAction: navEntry.call_to_action_name
        })
      );
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
    if (this.props.image !== undefined && 'src' in this.props.image) {
      imageWrapper = React.createElement('a', {href: target, className: 'navigtion_link_imgage_wrapper'},
        React.createElement('img', {src: this.props.image.src, alt: this.props.image.alt_text})
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
        className: 'navigtion_link_description',
        dangerouslySetInnerHTML: {
          __html: this.props.linkDescription
        }
      });
    }

    var callToAction;
    if (this.props.callToAction !== undefined) {
      callToAction = React.createElement('a', {
        href: target,
        className: 'navigtion_link_call_to_action_name'
      }, this.props.callToAction);
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
