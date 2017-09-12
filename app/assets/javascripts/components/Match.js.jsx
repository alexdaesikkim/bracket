var Match = React.createClass({
  getInitialState() {
    return {
      match_id: this.props.match.id,
      matchsets: this.props.matchsets || [],
      player1: this.props.player1,
      player2: this.props.player2,
      player1_score: this.props.match.player1_score,
      player2_score: this.props.match.player2_score
    };
  },

  handleAddSet(set){
    var newSets = this.state.matchsets;
    newSets.push(set);
    this.setState({
      matchsets: newSets
    })
  },

  handleScoreUpdate(p1_score, p2_score){
    this.setState({
      player1_score: p1_score,
      player2_score: p2_score
    });
  },

  render: function() {
    var addSet = this.handleAddSet;
    var updateSet = this.handleScoreUpdate;
    var matchSets = this.state.matchsets.map( function(set) {
      return (
        <Sets set={set} key={"set_"+set.id} updateScore={updateSet} />
      );
    });

    return (
      <div>
        <br/>
        <div>
          <div className="row">
            <div className="col-12">
              <center><h3>{this.state.player1.name} VS {this.state.player2.name}</h3>
              <br/>
              <h3>{this.state.player1_score} - {this.state.player2_score}</h3>
              <br/>
              </center>
            </div>
            <div className="col col-sm-12 col-md-6">
              <center>
                <MatchPlayer key={this.state.player1.name} match_id={this.state.match_id} player={this.state.player1} addSetToMatch={addSet} />
              </center>
            </div>
            <div className="col col-sm-12 col-md-6">
              <center>
                <MatchPlayer key={this.state.player2.name} match_id={this.state.match_id} player={this.state.player2} addSetToMatch={addSet} />
              </center>
            </div>
          </div>
          <div>
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
      addmatch: false,
      matchset: {
        name: '',
        level: '',
        difficulty: '',
        player1_score: 0,
        player2_score: 0,
        picked_player_id: this.props.player.id,
        match_id: this.props.match_id
      },
      player: this.props.player
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

  handleAddSet(){
    var that = this;
    $.ajax({
      method: 'POST',
      data: {
        matchset: that.state.matchset
      },
      url: '/matchsets.json',
      success: function(data){
        that.props.addSetToMatch(data);
        that.setState({
          addmatch: false,
          matchset: {
            name: '',
            level: '',
            difficulty: '',
            player1_score: 0,
            player2_score: 0,
            picked_player_id: that.props.player.id,
            match_id: that.props.match_id
          },
          player: that.props.player
        });
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  },

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
          <button className="btn btn-primary" onClick={this.handleAddSet}>Add Set</button>
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
