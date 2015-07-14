var ListOfArticlesBox = React.createClass({
  displayName: 'ListOfArticlesBox',
  loadArticlesFromServer: function () {
    $.ajax({
      url: this.props.url,
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
    return { data: [] };
  },
  componentDidMount: function () {
    this.loadArticlesFromServer();
  },
  render: function () {
    return (
      React.createElement('div', { className: 'overview-sidebar' },
        React.createElement(ItemList, { data: this.state.data })
      )
    );
  }
});

var ItemList = React.createClass({
  displayName: 'ItemList',
  render: function () {
    var articleNodes = [];
    if (this.props.data.articles !== undefined) {
      articleNodes = this.props.data.articles.map(function (article) {
        return (
          React.createElement(ListItem, {
            title: article.url_name,
            id: article.id,
            key: article.id,
            url_path: article.url_path,
            has_children: article.has_children
          })
        );
      });
    }
    return (
      React.createElement('ul', { className: 'overview-sidebar_list' },
        articleNodes
      )
    );
  }
});

var ChildrenList = React.createClass({
  displayName: 'ChildrenList',
  render: function () {
    var childNodes = [];
    if (this.props.data.articles !== undefined) {
      childNodes = this.props.data.articles.map(function (article) {
        return (
          React.createElement(ListItem, {
            title: article.url_name,
            id: article.id,
            key: article.id,
            url_path: article.url_path,
            has_children: article.has_children
          })
        );
      });
    }
    return (
      React.createElement('ul', { style: { display: 'none' } },
        childNodes
      )
    );
  }
});

var ListItem = React.createClass({displayName: 'ListItem',
  loadChildrenFromServer: function () {
    $.ajax({
      url: '/admin/articles/load_overviewtree_as_json?root_id=' + this.props.id,
      dataType: 'json',
      success: function (data) {
        this.setState({ data: data });
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
    if (this.props.has_children) {
      this.loadChildrenFromServer();
    }
  },
  render: function () {
    var restricted;
    if (this.props.restricted) {
      restricted = React.createElement('div', { className: 'secured' });
    } else {
      restricted = '';
    }

    var id = this.props.id;
    var showChildren;

    if (this.props.has_children) {
      showChildren = React.createElement(ChildrenList, { data: this.state.data });
    }

    return (
      React.createElement('li', { className: 'listItem', id: 'overview_item_' + id },
        React.createElement('div', { className: 'item' },
          React.createElement('div', { className: this.props.has_children ? 'folder' : 'last_folder' }),
          restricted,
          React.createElement('div', { className: 'title' },
            React.createElement('a', {
              href: '/admin/articles?q%5Bparent_ids_in%5D=' + id,
              title: 'Pfad anzeigen'
            }, this.props.title)
          ),
          React.createElement('div', { className: 'options' },
            React.createElement('a', {
              href: '/admin/articles/' + id + '/edit',
              className: 'edit_link',
              title: 'Bearbeiten'
            }, 'bearbeiten'),
            React.createElement('a', {
              href: '/admin/articles/new?parent=' + id,
              className: 'new_link',
              title: 'Neu'
            }, 'Neu')
          ),
          showChildren
        )
      )
    );
  }
});
