var Sets = React.createClass({
  getInitialState() {
    return {
      set: this.props.set,
      saved: this.props.set.saved,
      player1_score: this.props.set.player1_score,
      player2_score: this.props.set.player2_score
    };
  },

  handleScoreSubmitted(p1_score, p2_score, score1, score2){
    this.setState({
      player1_score: p1_score,
      player2_score: p2_score,
      saved: true
    });
    this.props.updateScore(score1, score2);
  },

  handleEditScore(){
    this.setState({
      saved: false
    });
  },

  //this.props.updateScore
  setForm(){
    if(!this.state.saved){
      return (
        <div>
          <div className="row">
            <div className="col-6">
              <SetScore key = {"p1_"+this.state.set.id} setId = {this.state.set.id} playerId = {1} score = {this.state.player1_score} updateScore = {this.handleScoreSubmitted} />
            </div>
            <div className="col-6">
              <SetScore key = {"p2_"+this.state.set.id} setId = {this.state.set.id} playerId = {2} score = {this.state.player2_score} updateScore = {this.handleScoreSubmitted} />
            </div>
          </div>
        </div>
      )
    }
    else{
      return (
        <div>
          <div className="row">
            <div className="col-6">
              <center>{this.state.player1_score}</center>
            </div>
            <div className="col-6">
              <center>{this.state.player2_score}</center>
            </div>
          </div>
          <center>
            <button className="btn btn-warning" onClick={this.handleEditScore}>Edit Set</button>
          </center>
        </div>
      )
    }
  },

  render: function() {
    return (
      <div>
        <br/>
        <div className="row">
          <div className="col-12">
            <center>
              <h3>{this.props.set.name}</h3>
              <br/>
              <h5>{this.props.set.difficulty} {this.props.set.level}</h5>
            </center>
            <br/>
          </div>
        </div>
        {this.setForm()}
      </div>
    );
  }
});

var SetScore = React.createClass({
  getInitialState(){
    return{
      setId: this.props.setId,
      score: this.props.score,
      saved: (this.props.score != 0)
    };
  },

  handleScoreChange(event){
    var score = this.state.score;
    score = event.target.value;
    this.setState({score: score});
  },


  handleEditMode(){
    var x = !this.state.saved;
    this.setState({
      saved: x
    });
  },

  submitPlayerScore(){
    var that = this;

    $.ajax({
      method: 'PUT',
      data: {
        player: this.props.playerId,
        score: this.state.score
      },
      url: '/matchsets/' + this.props.setId + '.json',
      success: function(data){
        console.log(data.saved)
        //if data.saved returns true then update score
        if(data.saved){
          that.setState({
            saved: true
          }, function(){
            that.props.updateScore(data.p1_score, data.p2_score, data.player1_score, data.player2_score);
          });
        }
        else{
          that.setState({
            saved: true
          });
        }
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  },

  playerScoreForm(){
    if(!this.state.saved){
      return(
        <div className="form-group">
          <input type="text" className="form-control input-sm" value={this.state.score} onChange={this.handleScoreChange}/>
          <button className="btn btn-info" onClick={this.submitPlayerScore}>Submit Score</button>
        </div>
      );
    }
    else {
      return(
        <div>
          {this.state.score}
          <br/>
          <button className="btn btn-warning" onClick={this.handleEditMode}>Edit Score</button>
        </div>
      );
    }
  },

  render: function(){
    return(
      <div>
        {this.playerScoreForm()}
      </div>
    );
  }


});
