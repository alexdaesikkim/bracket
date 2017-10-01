var Match = React.createClass({
  getInitialState() {
    return {
      match_id: this.props.match.id,
      matchsets: this.props.matchsets || [],
      player1: this.props.player1,
      player2: this.props.player2,
      player1_score: this.props.match.player1_score,
      player2_score: this.props.match.player2_score,
      p1_picks: this.props.player1_picks,
      p2_picks: this.props.player2_picks,
      submitted: (this.props.match.winner_id !== null)
    };
  },

  handleAddSet(set){
    //TODO: add to picks
    var newSets = this.state.matchsets;
    newSets.push(set);
    this.setState({
      matchsets: newSets
    })
  },

  handleScoreUpdate(p1_score, p2_score){
    console.log(p1_score);
    console.log(p2_score);
    this.setState({
      player1_score: p1_score,
      player2_score: p2_score
    });
  },

  submitMatch(){
    var winner_id = (this.state.player1_score > this.state.player2_score) ? this.state.player1.id : this.state.player2.id;
    var loser_id = (this.state.player1_score < this.state.player2_score) ? this.state.player1.id : this.state.player2.id;
    var tie = (this.state.player1_score == this.state.player2_score) ? true : false
    $.ajax({
      method: 'PUT',
      data: {
        winner_id: winner_id,
        loser_id: loser_id,
        tie: tie
      },
      url: '/matches/' + this.state.match_id + '.json',
      success: function(data){
        window.location = data.location;
        that.setState({
          submitted: true
        });
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  },

  submitButton(){
    if((this.state.player1_score != this.state.player2_score) && !this.state.submitted){
      return(
        <button type="button" className="btn btn-primary" onClick={this.submitMatch}>Finalize Match (Submit to Challonge)</button>
      );
    }
  },

  render: function() {
    var addSet = this.handleAddSet;
    var updateSet = this.handleScoreUpdate;
    var that = this
    var matchSets = this.state.matchsets.map( function(set) {
      return (
        <Sets set={set} key={"set_"+set.id} submitted = {that.state.submitted} updateScore={updateSet} />
      );
    });

    return (

      <div>
        <br/>
        <div>
          <div className="row">
            <div className="col col-sm-12 text-center">
              <h2>{this.state.player1.name} VS {this.state.player2.name}</h2>
              <br/>
              <h3>{this.state.player1_score} - {this.state.player2_score}</h3>
              <br/>
            </div>
          </div>
          <div>
            {matchSets}
          </div>


          <br />
          <div>
            <center>
              {this.submitButton()}
            </center>
          </div>
          <div className="text-center">
            <AddMatchSet player1={this.state.player1} player2={this.state.player2} p1_picks={this.state.p1_picks} p2_picks={this.state.p2_picks} match_id={this.state.match_id} addSetToMatch={addSet} />
          </div>
        </div>
      </div>
    );
  }
});

var AddMatchSet = React.createClass({
  getInitialState() {
    return {
      addset: false,
      player1: this.props.player1,
      player2: this.props.player2,
      p1_picks: this.props.p1_picks,
      p2_picks: this.props.p2_picks,
      matchset: {
        name: '',
        level: '',
        difficulty: '',
        player1_score: 0,
        player2_score: 0,
        match_id: this.props.match_id,
        picked_player_id: 0
      },
      player_name: '',
      player_picks: ''
    };
  },

  handleAddSetForm(){
    var bool = this.state.addset;
    this.setState({addset: !bool});
  },

  handlePickedP1(){
    var matchset = this.state.matchset;
    matchset.picked_player_id = this.state.player1.id;
    this.setState({
      matchset: matchset,
      player_name: this.state.player1.name
    });
  },

  handlePickedP2(){
    var matchset = this.state.matchset;
    matchset.picked_player_id = this.state.player2.id;
    this.setState({
      matchset: matchset,
      player_name: this.state.player2.name
    });
  },

  handlePickedRandom(){
    var matchset = this.state.matchset;
    matchset.picked_player_id = 0;
    this.setState({matchset: matchset});
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
          addset: false,
          matchset: {
            name: '',
            level: '',
            difficulty: '',
            player1_score: 0,
            player2_score: 0,
            picked_player_id: 0,
            match_id: that.props.match_id
          }
        });
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  },

  addSet(){
    if(this.state.matchset.picked_player_id != 0){
      return(
        <div className="row">
          <div className="col-sm-12 col-md-6">
            <div className="form-group text-justify">
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
            </div>
          </div>
          <div className="col-sm-12 col-md-6 text-justify">
            {this.state.player_name + "'"}s picks:
          </div>
          <div className="col-12">
            <div className="text-center">
              <button className="btn btn-primary" onClick={this.handleAddSet}>Add Set</button>
            </div>
          </div>
          <br/>
          <br/>
        </div>
      );
    }
    else return(
      <div>
        <button className="btn btn-primary">Add Random Song (Not supported yet)</button>
        <br/>
        <br/>
    </div>
    );
  },

  optionButtonGroup(){
    return(
      <div className= "center">
        <div className="btn-group" role="group" aria-label="Player ID">
          <button type="button" className="btn btn-primary" onClick={this.handlePickedP1}>{this.state.player1.name}</button>
          <button type="button" className="btn btn-warning" onClick={this.handlePickedRandom}>Random</button>
          <button type="button" className="btn btn-primary" onClick={this.handlePickedP2}>{this.state.player2.name}</button>
        </div>
      </div>
    );
  },

  setForm(){
    if(this.state.addset){
      return(
        <div>
          {this.optionButtonGroup()}
          <br/>
          {this.addSet()}
        </div>
      );
    }
  },

  render: function() {
    return (
      <div>
        <button type="button" className="btn btn-primary" onClick={this.handleAddSetForm}>Add New Set</button>
        <br/>
        <br/>
        {this.setForm()}
      </div>
    );
  }
});
