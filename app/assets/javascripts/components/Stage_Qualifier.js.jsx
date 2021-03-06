var Stage_Qualifier = React.createClass({
  getInitialState() {
    return {
      qualifiers: this.props.qualifiers || [],
      not_qualified: this.props.not_qualified || [],
      tied: this.props.ties || [],
      qualified: this.props.qualified || [],
      player:{
        name: '',
        phone: '',
        email: '',
        tournament_id: this.props.tournament_id
      },
      addPlayer: false,
      errors: []
    };
  },

  handlePlayerQualified(player, playerqualifiers){
    var qualified_players = this.state.qualified;

    var index = qualified_players.length;

    for(var i = 0; i < qualified_players.length; i++){
      if(player.qualifier_score > qualified_players[i].qualifier_score){
        index = i;
        i = qualified_players.length;
      }
    }

    player.playerqualifiers = playerqualifiers;

    player.seed = index+1;

    qualified_players.splice(index, 0, player);

    for(var i = index+1; i < qualified_players.length; i++){
      qualified_players[i].seed++;
    }

    this.setState({
      qualified: qualified_players
    });

    var not_qualified_players = this.state.not_qualified.filter(function(p) {
      return player.id !== p.id;
    });

    this.setState({
      not_qualified: not_qualified_players
    });
  },

  handleAddPlayer(){
    var that = this;
    $.ajax({
      method: 'POST',
      data: {
        player: that.state.player
      },
      url: '/players.json',
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
          }
        });
      },
      error: function(error){
        that.setState({errors: error.responseJSON})
      }
    });
  },

  handleAddPlayerForm(){
    var bool = this.state.addPlayer;
    this.setState({addPlayer: !bool});
  },

  handlePlayerNameChange(event){
    var player = this.state.player;
    player.name = event.target.value;
    this.setState({player: player});
  },

  handlePlayerPhoneChange(event){
    var player = this.state.player;
    player.phone = event.target.value;
    this.setState({player: player});
  },

  handlePlayerEmailChange(event){
    var player = this.state.player;
    player.email = event.target.value;
    this.setState({player: player});
  },

  player_form(){
    if(this.state.addPlayer == true){
      return(
        <div className="form-group">
          <div>
            Name:
            <input type="text" className="form-control input-sm" id="name" value={this.state.player.name} onChange={this.handlePlayerNameChange} />
          </div>
          <div>
            Phone:
            <input type="text" className="form-control input-sm" id="phone" value={this.state.player.phone} onChange={this.handlePlayerPhoneChange} />
          </div>
          <div>
            Email:
            <input type="text" className="form-control input-sm" id="email" value={this.state.player.email} onChange={this.handlePlayerEmailChange} />
          </div>
          <br/>
          <button className="btn btn-primary" onClick={this.handleAddPlayer}>Add Player</button>
        </div>
      );
    }
    else return null;
  },

  render: function() {
    var qualifiers = this.state.qualifiers;
    var callPlayerQualified = this.handlePlayerQualified;

    not_qualified_players = this.state.not_qualified.map( function(player) {
      return (
        <Not_Qualified player={player} key={"not_qualified_"+player.id} qualifiers={qualifiers} playerqualifiers={player.playerqualifiers} playerQualified={callPlayerQualified}/>
      );
    });

    qualified_players = this.state.qualified.map( function(player) {
      return (
        <Qualified player={player} key={"qualified_"+player.id} />
      );
    });

    errors = this.state.errors.map(function(error){
      return(
        <div>
          <br/>
          <div className="alert alert-danger" role="alert">
            {error}
          </div>
        </div>
      )
    });

    return (
      <div>
        <br/>
        <div>
          <button className="btn btn-primary" onClick = {this.handleAddPlayerForm}>Toggle Player Form (Add Player)</button>
          {errors}
          {this.player_form()}
        </div>
        <br/>
        <strong>Players Yet to Qualify</strong>
        <div id="accordion_not_qualified" role="tablist" aria-multiselectable="true">
          {not_qualified_players}
        </div>
        <br />
        <Tied players={this.state.tied} key={"tied"}/>
        <strong>Players who Qualified</strong>
        <div id="accordion" role="tablist" aria-multiselectable="true">
          {qualified_players}
        </div>
      </div>
    );
  }
});
