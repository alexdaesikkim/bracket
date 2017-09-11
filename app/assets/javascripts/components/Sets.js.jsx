var Sets = React.createClass({
  getInitialState() {
    return {
      set: this.props.set,
      saved: this.props.set.saved,
      player1_score: this.props.set.player1_score,
      player2_score: this.props.set.player2_score
    };
  },

  setForm(){
    if(!this.state.saved){
      return (
        <div>
          <div className="row">
            <div className="col-6">
              <SetScore key = {"p1_"+this.state.set.id} setId = {this.state.set.id} score = {this.state.set.player1_score} />
            </div>
            <div className="col-6">
              <SetScore key = {"p2_"+this.state.set.id} setId = {this.state.set.id} score = {this.state.set.player2_score} />
            </div>
          </div>
          <center>
            <button className="btn btn-primary">Submit Set</button>
          </center>
        </div>
      )
    }
    else{
      return (
        <div>
          <div className="row">
            <div className="col-6">
              <center>{this.state.set.player1_score}</center>
            </div>
            <div className="col-6">
              <center>{this.state.set.player2_score}</center>
            </div>
          </div>
          <center>
            <button className="btn btn-warning">Edit Set</button>
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
    if(this.state.score != 0 && this.state.saved == false){
      var x = !this.state.saved;
      this.setState({
        saved: x
      });
    }
  },

  submitPlayerScore(){
    var that = this;
/*    $.ajax({

    });
*/
    this.setState({
      saved: true
    });
  },

  playerScoreForm(){
    if(!this.state.saved){
      return(
        <div className="form-group">
          <input type="text" className="form-control input-sm" value={this.state.score} onChange={this.handleScoreChange}/>
          <button className="btn btn-info">Submit Score</button>
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
