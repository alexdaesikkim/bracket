var AddMatchSet = React.createClass({
  getInitialState() {
    return {
      addset: false,
      random: false,
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
      random_matchset:{
        name: '',
        level: '',
        difficulty: '',
        player1_score: 0,
        player2_score: 0,
        match_id: this.props.match_id,
        picked_player_id: 0
      },
      manual: false,
      player_name: '',
      player_picks: '',
      player1_class: 'btn btn-player1',
      player2_class: 'btn btn-player2',
      random_class: 'btn btn-warning',
      min_level: 0,
      max_level: 0
    };
  },

  handleAddSetForm(){
    var bool = this.state.addset;
    //is it taxing to change states when not needed?
    if(this.state.addset){
      this.setState({
        addset: false,
        random: false,
        player1_class: 'btn btn-player1',
        player2_class: 'btn btn-player2',
        matchset: {
          name: '',
          level: '',
          difficulty: '',
          player1_score: 0,
          player2_score: 0,
          match_id: this.props.match_id,
          picked_player_id: 0
        },
        random_matchset:{
          name: '',
          level: '',
          difficulty: '',
          player1_score: 0,
          player2_score: 0,
          match_id: this.props.match_id,
          picked_player_id: 0
        },
        manual: '',
        min_level: 0,
        max_level: 0
      });
    }
    else{
      this.setState({
        addset: true
      });
    }
  },

  handlePickedP1(){
    var matchset = this.state.matchset;
    matchset.picked_player_id = this.state.player1.id;
    this.setState({
      matchset: matchset,
      player_name: this.state.player1.name,
      player1_class: 'btn btn-player1-active',
      player2_class: 'btn btn-player2'
    });
  },

  handlePickedP2(){
    var matchset = this.state.matchset;
    matchset.picked_player_id = this.state.player2.id;
    this.setState({
      matchset: matchset,
      player_name: this.state.player2.name,
      player1_class: 'btn btn-player1',
      player2_class: 'btn btn-player2-active'
    });
  },

  handlePickedRandom(){
    var matchset = this.state.matchset;
    matchset.picked_player_id = 0;
    this.setState({matchset: matchset});
  },

  handleButtonRandomAuto(){
    this.setState({
      manual: false
    })
  },

  handleButtonRandomManual(){
    this.setState({
      manual: true
    })
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

  handleMinLevelChange(event){
    this.setState({
      min_level: event.target.value
    })
  },

  handleMaxLevelChange(event){
    this.setState({
      max_level: event.target.value
    })
  },

  handleAddRandomSet(){
    this.setState({
      matchset: this.state.random_matchset
    }, function(){
      this.handleAddSet();
    })
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
          random: false,
          matchset: {
            name: '',
            level: '',
            difficulty: '',
            player1_score: 0,
            player2_score: 0,
            picked_player_id: 0,
            match_id: that.props.match_id
          },
          random_matchset:{
            name: '',
            level: '',
            difficulty: '',
            player1_score: 0,
            player2_score: 0,
            picked_player_id: 0,
            match_id: this.props.match_id,
          },
          manual: false,
          min_level: 0,
          max_level: 0
        });
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  },

  getRandomSong(){
    var that = this;
    //todo: add "retrieving" view
    $.ajax({
      method: 'GET',
      data: {
        id: that.props.game_id,
        min_level: that.state.min_level,
        max_level: that.state.max_level
      },
      url: '/games/' + that.props.game_id + '/random.json',
      success: function(data){
        that.setState({
          random_matchset:{
            name: data.name,
            difficulty: data.difficulty,
            level: data.level,
            player1_score: 0,
            player2_score: 0,
            match_id: that.props.match_id,
            picked_player_id: 0
          },
          errors: {},
        });
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
    //set qualifier state
    //add to qualifiers, using above code. voila!

  },

  randomSong(){

  },

  randomSongForm(){
    if(this.state.manual){
      return(
        <div>
          {this.addSongForm()}
          <br/>
          <button className="btn btn-primary">Submit (Placeholder)</button>
        </div>
      )
    }
    else{
      if(this.state.random_matchset.name === ''){
        return(
          <div className="col-sm-12 col-md-6">
            Min Level:
            <br/>
            <input type="number" className="form-control input-sm" id="min_level" value={this.state.min_level} onChange={this.handleMinLevelChange}></input>
            Max Level:
            <br/>
            <input type="number" className="form-control input-sm" id="max_level" value={this.state.max_level} onChange={this.handleMaxLevelChange}></input>
            <button className="btn btn-primary" onClick={this.getRandomSong}>Grab Song</button>
            <br/>
            <br/>
          </div>
        )
      }
      else{
        return(
          <div className="col-sm-12 col-md-6 text-center">
            {this.state.random_matchset.name}
            <br/>
            {this.state.random_matchset.difficulty} {this.state.random_matchset.level}
            <br/>
            <button className="btn btn-primary" onClick={this.handleAddRandomSet}>Submit</button>
            <button className="btn btn-secondary" onClick={this.getRandomSong}>Grab Another</button>
            <br/>
            <br/>
          </div>
        )
      }
    }
  },

  addSongForm(){
    return(
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
    );
  },


  addSet(){
    //add another function for random, maybe another state?
    //todo when curious: how many states can i use without having to worry about time/sapce complexity stuff?
    if(this.state.matchset.picked_player_id !== 0){
      return(
        <div className="row justify-content-center">
          {this.addSongForm()}
          <div className="col-sm-12 col-md-6 text-justify">
            {this.state.player_name + "'"}s picks:
          </div>
          <div className="col-12">
            <div className="text-center">
              <button className="btn btn-secondary" onClick={this.handleAddSet}>Add Set</button>
            </div>
          </div>
          <br/>
          <br/>
        </div>
      );
    }
    else return(
      <div className="row justify-content-center">
        {this.randomSongForm()}
        <br/>
        <br/>
      </div>
    );
  },

  optionButtonGroup(){
    return(
      <div className= "center">
        <div className="btn-group" role="group" aria-label="Player ID">
          <button type="button" className={this.state.player1_class} onClick={this.handlePickedP1}>{this.state.player1.name}</button>
          <button type="button" className={this.state.random_class} onClick={this.handlePickedRandom}>Random Song</button>
          <button type="button" className={this.state.player2_class} onClick={this.handlePickedP2}>{this.state.player2.name}</button>
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
        <button type="button" className="btn btn-primary" onClick={this.handleAddSetForm}>Toggle New Set</button>
        <br/>
        <br/>
        {this.setForm()}
      </div>
    );
  }
});
