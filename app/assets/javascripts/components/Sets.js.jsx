var Sets = React.createClass({
  getInitialState() {
    return {
      set: this.props.set,
      saved: this.props.set.saved,
      player1_score: this.props.set.player1_score,
      player2_score: this.props.set.player2_score,
      card_header: ((this.props.set.player1_score == this.props.set.player2_score) ? 'card-header' : (this.props.set.player1_score > this.props.set.player2_score ? 'card-header-player1' : 'card-header-player2')),
      submitted: this.props.submitted,
      player1_check: ((this.props.set.player1_score > this.props.set.player2_score) && this.props.set.saved ? '✓' : ''),
      player2_check: ((this.props.set.player1_score < this.props.set.player2_score) && this.props.set.saved ? '✓' : '')
    };
  },

  handleScoreSubmitted(p1_score, p2_score, score1, score2){
    var p1_check = ((p1_score > p2_score) ? '✓' : '');
    var p2_check = ((p2_score > p1_score) ? '✓' : '');
    this.setState({
      player1_score: p1_score,
      player2_score: p2_score,
      player1_check: p1_check,
      player2_check: p2_check,
      saved: true
    });
    this.props.updateScore(score1, score2);
  },

  handleEditScore(){
    this.setState({
      saved: false
    });
  },

  editButton(){
    if(!this.state.submitted){
      return(
        <button className="btn btn-warning" onClick={this.handleEditScore}>Edit Set</button>
      );
    }
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
            {this.editButton()}
          </center>
        </div>
      )
    }
  },

  render: function() {
    return (
    <div>
      <div className="card">
        <div className={this.state.card_header} role="tab" id= {"set_heading_"+this.state.set.id} >
          <div className="row">
            <div className="col-1 text-center">
              <h5>
                {this.state.player1_check}
              </h5>
            </div>
            <div className="col-10 text-center">
              <h5>
                <a data-toggle="collapse" data-parent="#accordion" href= {"#set_collapse_"+this.state.set.id} aria-expanded="true" aria-controls= {"set_collapse_"+this.state.set.id}>
                  {this.props.set.name}
                </a>
              </h5>
            </div>
            <div className="col-1 text-center">
              <h5>
                {this.state.player2_check}
              </h5>
            </div>
          </div>
        </div>
        <div id= {"set_collapse_"+this.state.set.id} className="collapse" role="tabpanel" aria-labelledby= {"set_heading_"+this.state.set.id} >
          <div className="card-body">
            <div className="text-center">
              {this.props.set.difficulty} {this.props.set.level}
            </div>
            {this.setForm()}
          </div>
        </div>
      </div>
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
          <input type="number" className="form-control input-sm" value={this.state.score} onChange={this.handleScoreChange}/>
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
