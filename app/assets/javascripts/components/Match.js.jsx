var Match = React.createClass({
  getInitialState() {
    return {
      matchsets: this.props.matches || [],
      player1: this.props.player1,
      player2: this.props.player2
    };
  },

  handleAddSet(set){
    var newSets = this.state.matchsets;
    newSets.push(set);
    this.setState({
      matchsets: newSets
    })
  },

  render: function() {
    var addSet = this.handleAddSet;

    var matchSets = this.state.matchsets.map( function(set) {
      return (
        <Sets set={set} key={"set_"+set.id} />
      );
    });

    return (
      <div>
        <br/>
        <div>
          <div className="row">
            <div className="col-12">
              <center><h3>{this.state.player1.name} VS {this.state.player2.name}</h3></center>
              <br/>
            </div>
            <div className="col col-sm-12 col-md-6">
              <center>
                <MatchPlayer key={this.state.player1.name} player={this.state.player1} addSetToMatch={addSet} />
              </center>
            </div>
            <div className="col col-sm-12 col-md-6 center">
              <center>
                <MatchPlayer key={this.state.player2.name} player={this.state.player2} addSetToMatch={addSet} />
              </center>
            </div>
          </div>
          <div className="row">
            {matchSets}
          </div>
        </div>
      </div>
    );
  }
});

var MatchPlayer = React.createClass({
  getInitialState() {
    return {
      player: this.props.player,
      addmatch: false,
      matchset: {
        name: '',
        level: '',
        difficulty: '',
        player1_score: 0,
        player2_score: 0,
        player: this.props.player.id
      }
    };
  },

  handleAddMatchForm(){
    var bool = this.state.addmatch;
    this.setState({addmatch: !bool});
  },

  handleSongNameChange(event){
    var matchset = this.state.matchset;
    matchset.name = event.target.value;
    this.setState({matchset: matchset});
  },

  handleSongLevelChange(event){
    var matchset = this.state.matchset;
    matchset.level = event.target.value;
    this.setState({matchset: matchset});
  },

  handleSongDifficultyChange(event){
    var matchset = this.state.matchset;
    matchset.difficulty = event.target.value;
    this.setState({matchset: matchset});
  },

  submitAddSet(){
    this.props.addSetToMatch(this.state.matchset);
    this.setState({
      addmatch: false,
      matchset: {
        name: '',
        level: '',
        difficulty: '',
        player1_score: 0,
        player2_score: 0,
        player: this.state.player.id
      }
    });
  },
/*
  handleAddSet(){
    var that = this;
    $.ajax({
      method: 'POST',
      data: {
        song: that.state.song
        player: that.state.player
      },
      url: '/matchsets.json',
      success: function(data){
        var newNotQualifiedList = that.state.not_qualified;
        newNotQualifiedList.push(data);
        that.setState({
          not_qualified: newNotQualifiedList,
          player:{
            name: '',
            phone: '',
            email: '',
            tournament_id: that.props.tournament_id
          },
          addPlayer: false
        });
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  }
*/

  addMatchPlayer(){
    if(this.state.addmatch == true){
      return(
        <div className="form-group">
          <div>
            Song Name:
            <input type="text" className="form-control input-sm" id="name" value={this.state.matchset.name} onChange={this.handleSongNameChange} />
          </div>
          <div>
            Song Level:
            <input type="text" className="form-control input-sm" id="level" value={this.state.matchset.level} onChange={this.handleSongLevelChange} />
          </div>
          <div>
            Song Difficulty:
            <input type="text" className="form-control input-sm" id="difficulty" value={this.state.matchset.difficulty} onChange={this.handleSongDifficultyChange} />
          </div>
          <br/>
          <button className="btn btn-primary" onClick={this.submitAddSet}>Add Set</button>
        </div>
      );
    }
    else return null;
  },

  render: function() {
    return (
      <div>
        <strong>{this.state.player.name}</strong>
        <br/>
        <button className="btn btn-primary" onClick = {this.handleAddMatchForm}>Add New Set {this.state.player.name}</button>
        {this.addMatchPlayer()}
      </div>
    );
  }
});
