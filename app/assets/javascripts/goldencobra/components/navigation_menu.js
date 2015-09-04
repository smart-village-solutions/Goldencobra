var App;
var NavigationMenu = React.createClass({displayName: 'NavigationMenu',
  menuUrl: function () {
    var idToSend = this.props.menuId !== undefined ? 'id=' + this.props.menuId : '';
    var nameToSend = this.props.menuName !== undefined ? '&name=' + this.props.menuName : '';
    var targetToSend = this.props.menuTarget !== undefined ? '&target=' + this.props.menuTarget : '';
    var methods = '&methods=css_class' + (this.props.methods && this.props.methods.length ? ',' + this.props.methods : '');
    var depth = this.props.depth !== undefined ? '&depth=' + this.props.depth : '';
    var filterClasses = this.props.filterClasses && this.props.filterClasses.length ? '&filter_classes=' + this.props.filterClasses : '';
    var offset = this.props.offset !== undefined ? '&offset=' + this.props.offset : '';
    return '/api/v2/navigation_menus.json?' + idToSend + nameToSend + targetToSend + methods + depth + filterClasses + offset;
  },
  loadMenuFromServer: function () {
    var that = this;
    $.ajax({
      url: this.menuUrl(),
      dataType: 'json',
      success: function (data) {
        // If available and enabled use a handler() to massage JSON data for the specific application
        if ((that.props.handleData === true || that.props.handleData === 'true') && App !== undefined && App.navigationMenuHandler !== undefined) {
          App.navigationMenuHandler.handleMenuData(data, function(nextData) {
            that.setState({data: nextData});
          });
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
    var classNames;
    if (this.props.classNames !== undefined && this.props.classNames.length) {
      classNames = this.props.classNames + ' navigation';
    } else {
      classNames = 'navigation';
    }
    return (
      React.createElement(NavigationList, {
        data: this.state.data,
        id: this.props.id,
        className: classNames,
        depth: this.props.depth !== undefined ? this.props.depth : 1
      })
    );
  }
});

var NavigationList = React.createClass({displayName: 'NavigationList',
  getInitialState: function () {
    return {
      data: [],
      activePath: []
    };
  },
  componentDidMount: function () {
    var pathname = window.location.pathname;
    var origin = window.location.origin ? window.location.origin : window.location.origin = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port: '');
    if (App !== undefined) {
      this.setState({activePath: App.activePath});
    }
  },
  componentDidUpdate: function (prevProps, prevState) {
    if (App !== undefined && App.navigationFinishedHandler !== undefined) {
      App.navigationFinishedHandler.handleFinished(this.props.id);
    }
  },
  render: function () {
    var that = this;
    var setActive = function (item) {
      var index = that.state.activePath.indexOf(item.id);
      if (index !== -1) {
        return (index == that.state.activePath.length - 1 ? ' active' : ' has_active_child');
      } else {
        return '';
      }
    };
    var navigationNodes = this.props.data.map(function (navEntry) {
      return (
        React.createElement(NavigationListItem, {
          id: navEntry.id,
          key: navEntry.id,
          children: navEntry.children,
          title: navEntry.title,
          target: navEntry.target,
          linkDescription: navEntry.liquid_description,
          css_class: navEntry.css_class + setActive(navEntry),
          image: navEntry.navigation_image,
          descriptionTitle: navEntry.description_title,
          callToAction: navEntry.call_to_action_name,
          depth: that.props.depth !== undefined ? that.props.depth : 1
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
  componentDidUpdate: function (prevProps, prevState) {
    if (App !== undefined && App.navigationFinishedHandler !== undefined) {
      App.navigationFinishedHandler.handleFinished(this.props.id);
    }
  },
  render: function () {
    var depth;
    if (this.props.depth !== undefined) {
      depth = parseInt(this.props.depth);
    } else {
      depth = 1;
    }

    var classNames = this.props.css_class;
    var target = this.props.target;

    if (this.props.children.length && this.props.target != '/') {
      classNames += ' has_children';
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
    if (this.props.children.length && classNames.indexOf('hidden_childs') === -1) {
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
