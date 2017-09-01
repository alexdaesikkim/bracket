var Sets = React.createClass({
  getInitialState() {
    return {
      set: this.props.set,
      saved: this.props.set.saved,
      p1_saved: (this.props.set.player1_score != 0),
      p2_saved: (this.props.set.player2_score != 0),
      player1_score: this.props.set.player1_score,
      player2_score: this.props.set.player2_score
    };
  },

  handleChangeScoreForm(){
    if(this.state.p1_saved && this.state.p2_saved){
      this.setState({
        saved: true
      });
    }
  },

  handleP1ScoreUpdate(score){
    //do the ajax call here for score
    var that = this;
    $.ajax({
      method: 'PUT',
      data: {
        matchset:{
          player1_score: score
        }
      },
      url: '/matchsets/' + that.props.set.id + '.json',
      success: function(data){
        that.setState({
          player1_score: score,
          p1_saved: true
        });
        if(that.state.p2_saved){
          that.setState({
            saved: true
          });
          //call parent function
          var flag = 0;
          if(score > that.state.player2_score) flag = 1;
          else if (that.state.player2_score > score) flag = 2;
          that.props.update(flag);
        }
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  },

  handleP2ScoreUpdate(score){
    var that = this;
    $.ajax({
      method: 'PATCH',
      data: {
        matchset:{
          player2_score: score
        }
      },
      url: '/matchsets/' + that.props.set.id + '.json',
      success: function(data){
        that.setState({
          player2_score: score,
          p2_saved: true
        });
        if(that.state.p1_saved){
          that.setState({
            saved: true
          })
          var flag = 0;
          if(that.state.player1_score > score) flag = 1;
          else if(score > that.state.player1_score) flag = 2;
          that.props.update(flag);
        }
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  },

  handleEditSetScore(){
    var flag = 0;
    if(this.state.player1_score > this.state.player2_score) flag = -1;
    else if (this.state.player2_score > this.state.player1_score) flag = -2;
    this.props.update(flag);
    this.setState({
      p1_saved: false,
      p2_saved: false,
      saved: false
    });
  },

  setForm(){
    if(!this.state.saved){
      return (
        <div>
          <div className="row">
            <div className="col-6">
              <SetScore key = {"p1_"+this.state.set.id} saved = {this.state.p1_saved} setId = {this.state.set.id} score = {this.state.player1_score} identifier = "player1" update = {this.handleP1ScoreUpdate}/>
            </div>
            <div className="col-6">
              <SetScore key = {"p2_"+this.state.set.id} saved = {this.state.p2_saved} setId = {this.state.set.id} score = {this.state.player2_score} identifier = "player2" update = {this.handleP2ScoreUpdate}/>
            </div>
          </div>
        </div>
      )
    }
    else{
      if(this.state.player1_score > this.state.player2_score){
        return (
          <div>
            <div className="row">
              <div className="col-6">
                <strong>
                  <center>{this.state.player1_score}</center>
                </strong>
              </div>
              <div className="col-6">
                <center>{this.state.player2_score}</center>
              </div>
            </div>
            <center>
              <button className="btn btn-warning" onClick={this.handleEditSetScore}>Edit Set</button>
            </center>
          </div>
        )
      }
      else if(this.state.player2_score > this.state.player1_score){
        return (
          <div>
            <div className="row">
              <div className="col-6">
                <center>{this.state.player1_score}</center>
              </div>
              <div className="col-6">
                <strong>
                  <center>{this.state.player2_score}</center>
                </strong>
              </div>
            </div>
            <center>
              <button className="btn btn-warning" onClick={this.handleEditSetScore}>Edit Set</button>
            </center>
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
              <button className="btn btn-warning" onClick={this.handleEditSetScore}>Edit Set</button>
            </center>
          </div>
        )
      }
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
      saved: this.props.saved
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
    this.props.update(this.state.score);
    this.setState({
      saved: true
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
