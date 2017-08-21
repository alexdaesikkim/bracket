var Sets = React.createClass({
  getInitialState() {
    return {
      set: this.props.set,
      saved: ((this.props.set.player1_score != 0) && (this.props.set.player2_score != 0))
    };
  },

  render: function() {
    return (
      <div>
        <br/>
        <div>
          <div className="row">
            <div className="col-12">
              <center><h5>{this.props.set.name}</h5></center>
              <br/>
            </div>
            <div className="col-6">
              <SetScore key = {"p1_"+this.state.set.id} setId = {this.state.set.id} score = {this.state.set.player1_score} />
            </div>
            <div className="col-6">
              <SetScore key = {"p2_"+this.state.set.id} setId = {this.state.set.id} score = {this.state.set.player2_score} />
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
          <button className="btn btn-primary">Submit</button>
          <button className="btn btn-warning" onClick={this.handleEditMode}>Cancel</button>
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
        TESTING STUFF PLEASE DONt MIND
        {this.playerScoreForm()}
      </div>
    );
  }


});
