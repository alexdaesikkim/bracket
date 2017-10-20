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
      submitted: (this.props.match.winner_id !== null),
      game_id: this.props.game_id
      //need another function to check if all matches have been submitted?
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
    var winner_id = (this.state.player1_score > this.state.player2_score) ? this.state.player1 : this.state.player2.id;
    var loser_id = (this.state.player1_score < this.state.player2_score) ? this.state.player1 : this.state.player2.id;
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
      var winner_name = (this.state.player1_score > this.state.player2_score) ? this.state.player1.name : this.state.player2.name;
      var loser_name = (this.state.player1_score < this.state.player2_score) ? this.state.player1.name : this.state.player2.name;

      var winner_score = (this.state.player1_score > this.state.player2_score) ? this.state.player1_score : this.state.player2_score;
      var loser_score = (this.state.player1_score < this.state.player2_score) ? this.state.player1_score : this.state.player2_score;

      return(
        <div>
          <button type="button" className="btn btn-primary" data-toggle="modal" data-target="#submitModal">
            Submit Match
          </button>

          <div className="modal fade" id="submitModal" tabIndex="-1" role="dialog" aria-labelledby="submitModalLabel" aria-hidden="true">
            <div className="modal-dialog" role="document">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title" id="submitModalLabel">Confirmation</h5>
                  <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div className="modal-body">
                  <h5>
                    The winner is:
                    <br/>
                    {winner_name}
                    <br/>
                    <br/>
                    The score for this match is:
                    <br/>
                    {winner_name} - {winner_score}
                    <br/>
                    {loser_name} - {loser_score}
                    <br/>
                    <br/>
                    Would you like to submit and finalize the match?
                  </h5>
                </div>
                <div className="modal-footer">
                  <button type="button" className="btn btn-secondary" data-dismiss="modal">Cancel</button>
                  <button type="button" className="btn btn-primary" onClick={this.submitMatch}>Finalize Match</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      );
    }
  },

  render: function() {
    var addSet = this.handleAddSet;
    var updateSet = this.handleScoreUpdate;
    var that = this;
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
          <br/>
          <div className="text-center">
            <AddMatchSet player1={this.state.player1} player2={this.state.player2} p1_picks={this.state.p1_picks} p2_picks={this.state.p2_picks} match_id={this.state.match_id} game_id={this.state.game_id} addSetToMatch={addSet} />
          </div>
          <div>
            <center>
              {this.submitButton()}
            </center>
          </div>
        </div>
      </div>
    );
  }
});
