var Qualifier_Songs = React.createClass({
  getInitialState() {
    return {
      song: this.props.song
    };
  },

  handleRemoveSong(){
    //was VERY HACKY T_T
    //reminder: ajax variables don't work that well, assign something else before calling "this.state" within ajax success call
    //long time goal: figure out why this is a thing
    var that = this;
    $.ajax({
      method: 'DELETE',
      url: '/qualifiers/' + this.state.song.id + '.json',
      success: function(data) {
        that.props.removeSong(that.state.song);
      }
    });
  },

  render: function() {
    return (
      <div className="card">
        <h4 className="card-header">{"Song #"+this.state.song.number}</h4>
        <div className="card-block">
          <h5 className="card-title">{this.state.song.name}</h5>
          <h5 className="card-text">{this.state.song.difficulty}</h5>
          <h5 className="card-text">{"Level: " + this.state.song.level}</h5>
          <button className="btn btn-danger" onClick={this.handleRemoveSong}>Delete</button>
        </div>
      </div>
    );
  }
});
