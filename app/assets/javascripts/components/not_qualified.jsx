var Not_Qualified = React.createClass({

  getInitialState() {
    return {
      player: this.props.player,
      player_qualifiers: this.props.playerqualifiers,
      total_score: 0
    };
  },

  addQualifierScores(name, score){
    playerqualifiers = this.state.player_qualifiers;

    this.setState({
      player_qualifiers: playerqualifiers
    }, function(){
      this.checkQualifierFinished();
    });
  },

  checkQualifierFinished(){

    //bug: i think this doesn't work for array of size one
    //before checking, have to update the list for player_qualifiers with appropriate scores
    var check = this.state.player_qualifiers.reduce( function(pq1, pq2){
      return (pq1.submitted && pq2.submitted);
    });
    if(check){
      console.log("hi");
      var score = this.state.player_qualifiers.reduce( function(total, pq){
        console.log(pq.score);
        return (total + parseInt(pq.score));
      }, 0);
      //self question: why am i updating the score here? shouldn't I get this data from ajax call?
      player = this.state.player;
      player.qualifier_score = score;
      this.setState({
        player: player
      }, function() {
        this.props.playerQualified(this.state.player, this.state.player_qualifiers);
      });
    }
  },

  render: function() {

    var addScore = this.addQualifierScores;
    var qualifierform = this.state.player_qualifiers.map( function(playerqualifier) {
      return (
        <Qualifier_Forms playerqualifier={playerqualifier} qualifier={playerqualifier.qualifier} key={"qualifier_song_"+playerqualifier.id} check={addScore} qualified={false}/>
      );
    });

    return (
      <div className="card">
        <div className="card-header" role="tab" id= {"not_qualified_heading_" + this.state.player.id} >
          <h5 className="mb-0">
            <a data-toggle="collapse" data-parent="#accordion_not_qualified" href= {"#not_qualified_collapse_"+this.state.player.id} aria-expanded="true" aria-controls= {"not_qualified_collapse_"+this.state.player.id}>
              {this.state.player.name}
            </a>
            <span style={{float: 'right'}}></span>
          </h5>
        </div>
        <div id= {"not_qualified_collapse_"+this.state.player.id} className="collapse" role="tabpanel" aria-labelledby= {"not_qualified_heading_" + this.state.player.id} >
          <div className="card-block">
            <div className="row">
              <div className= "col-12 col-lg-6">
                {qualifierform}
              </div>
              <div className= "col-12 col-lg-6">
                <strong>Contact Info:</strong>
                <br/>
                {this.state.player.phone}
                <br/>
                {this.state.player.email}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

var Qualifier_Forms = React.createClass({
  getInitialState(){
    return{
      playerqualifier: this.props.playerqualifier,
      qualifier: this.props.qualifier,
      score: this.props.playerqualifier.score,
      submitted: this.props.playerqualifier.submitted,
      qualified: this.props.qualified
    };
  },

  handleSubmitScore(){
    var that = this;
    var playerqualifier = this.state.playerqualifier;
    playerqualifier.score = this.state.score;
    playerqualifier.submitted = true;
    $.ajax({
      method: 'POST',
      data: {
        player_id: playerqualifier.player_id,
        id: playerqualifier.id,
        score: playerqualifier.score
      },
      url: '/playerqualifiers/update_qualifier.json',
      success: function(data){
        that.setState({submitted: true});
        if(that.props.qualified){
          that.props.check(playerqualifier.score);
        }
        else{
          that.props.check();
        }
      }
    });
  },

  handleEditScore(){
    this.setState({submitted: false});
  },

  handleScoreChange(event){
    var qualifier_score = this.state.score;
    qualifier_score = event.target.value;
    this.setState({score: qualifier_score});
  },

  render: function() {
    if(this.state.submitted == true){
      return (
        <div>
          <strong>{this.state.qualifier.name}</strong>
          <br/>
          Level: {this.state.qualifier.level}
          <br/>
          Score: {this.state.score}
          <br/>
          <button className="btn btn-warning" onClick={this.handleEditScore}>Edit</button>
          <br/>
          <br/>
        </div>
      );
    }
    else{
      return (
        <div>
          <strong>{this.state.qualifier.name}</strong>
          <br/>
          Level: {this.state.qualifier.level}
          <br/>
          <input type="text" className="form-control input-sm" id={"score_"+this.state.qualifier.id} value={this.state.score} onChange={this.handleScoreChange} />
          <br/>
          <button className="btn btn-primary" onClick={this.handleSubmitScore}>Submit Score</button>
          <br/>
          <br/>
        </div>
      );
    }
  }
});
