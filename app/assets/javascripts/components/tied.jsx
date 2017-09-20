var Tied = React.createClass({
  getInitialState() {
    return {
      players: this.props.players,
      tiebreakers: []
    };
  },

  addTiebreakerSong(){

  },

  render() {
    return (
      <div>
        <strong>Players with Ties</strong>
        <br />
        <br/>
      </div>

    );
  }
});

var Tied_Player = React.createClass({
  getInitialState() {
    return{
      player: this.props.player,
      tiebreakers: this.props.tiebreakers
    }
  },

  render() {
    return (
      <div className="card" key={"tied_"+this.state.player.id}>
        <div className="card-header" role="tab" id= {"tied_heading_" + this.state.player.id} >
          <h5 className="mb-0">
            <a data-toggle="collapse" data-parent="#accordion" href= {"#tied_collapse_"+this.state.player.id} aria-expanded="true" aria-controls= {"tied_collapse_"+this.state.player.id}>
              {this.state.player.name}
            </a>
          </h5>
        </div>
        <div id= {"tied_collapse_"+this.state.player.id} className="collapse" role="tabpanel" aria-labelledby= {"tied_heading_" + this.state.player.id} >
          <div className="card-body">
            {this.state.player.qualifier_score}
            <br />
            Tiebreaker score:
          </div>
        </div>
      </div>
    );
  }
});;
