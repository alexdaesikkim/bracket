var PreQualifiers = React.createClass({
  getInitialState() {
    return {
      qualifiers: this.props.qualifiers || [],
      qualifier:{
        name: '',
        difficulty: '',
        level: '',
        tournament_id: this.props.tournament_id
      },
      random:{
        min_level: this.props.game.min_level,
        max_level: this.props.game.max_level,
      },
      random_song:{
        name: '',
        difficulty: '',
        level: '',
        tournament_id: this.props.tournament_id
      },
      game_id: this.props.game.id,
      song_manual: false,
      song_random: false,
      errors: {}
    };
  },

  handleNameChange(event){
    var newSong = this.state.qualifier;
    newSong.name = event.target.value;
    this.setState({qualifier: newSong});
  },

  handleDifficultyChange(event){
    var newSong = this.state.qualifier;
    newSong.difficulty = event.target.value;
    this.setState({qualifier: newSong});
  },

  handleLevelChange(event){
    var newSong = this.state.qualifier;
    newSong.level = event.target.value;
    this.setState({qualifier: newSong});
  },

  handleMinLevelChange(event){
    var random = this.state.random;
    random.min_level = event.target.value;
    this.setState({random: random});
  },

  handleMaxLevelChange(event){
    var random = this.state.random;
    random.max_level = event.target.value;
    this.setState({random: random});
  },

  handleAddSong(){
    var that = this;
    console.log("method has been called")
    $.ajax({
      method: 'POST',
      data: {
        qualifier: this.state.qualifier
      },
      url: '/qualifiers.json',
      success: function(data){
        var newQualifierList = that.state.qualifiers;
        newQualifierList.push(data);
        that.setState({
          qualifiers: newQualifierList,
          qualifier:{
            name:'',
            difficulty:'',
            level:'',
            tournament_id: that.props.tournament_id
          },
          random_song:{
            name:'',
            difficulty:'',
            level:'',
            tournament_id: that.props.tournament_id
          },
          errors: {},
        });
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  },

  addRandomSong(){
    this.setState({
      qualifier: this.state.random_song
    }, function(){
      console.log("HI");
      this.handleAddSong();
    })
  },

  handleGetRandomSong(){
    var that = this;
    //todo: add "retrieving" view
    $.ajax({
      method: 'GET',
      data: {
        id: that.state.game_id,
        min_level: that.state.random.min_level,
        max_level: that.state.random.max_level
      },
      url: '/games/' + that.state.game_id + '/random.json',
      success: function(data){
        that.setState({
          random_song:{
            name: data.name,
            difficulty: data.difficulty,
            level: data.level,
            tournament_id: that.state.random_song.tournament_id
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

  handleAddSongManualForm(){
    if(this.state.song_manual == true){
      this.setState({song_manual: false});
    }
    else{
      this.setState({song_manual: true});
      this.setState({song_random: false});
    }
  },

  handleAddSongRandomForm(){
    if(this.state.song_random == true){
      this.setState({song_random: false});
    }
    else{
      this.setState({song_random: true});
      this.setState({song_manual: false});
    }
  },

  removeSongFromList(removedSong){
    var qualifierSongList = this.state.qualifiers.filter(function(song){
      return song.id !== removedSong.id;
    });

    qualifierSongList.map(function(song){
      if(song.number > removedSong.number) song.number--;
    });

    this.setState({qualifiers: qualifierSongList});
  },

  addManualSongForm(){
    if(this.state.song_manual == true) {
      return(
        <div className="form-group">
          <div>
            Song Name:
            <input type="text" className="form-control" id="name" value={this.state.qualifier.name} onChange={this.handleNameChange} />
          </div>
          <div>
            Song Difficulty:
            <input type="text" className="form-control" id="difficulty" value={this.state.qualifier.difficulty} onChange={this.handleDifficultyChange} />
          </div>
          <div>
            Song Level:
            <input type="number" className="form-control" id="level" value={this.state.qualifier.level} onChange={this.handleLevelChange} />
          </div>
          <br/>
          <button className="btn btn-primary" onClick={this.handleAddSongManual}>Add Song</button>
        </div>
      );
    }
    else return null;
  },

  randomSongDisplay(){
    if(this.state.random_song.name != ''){
      return(
        <div className="row">
          <div className="col-12">
            {this.state.random_song.name}
          </div>
          <div className="col-12">
            {this.state.random_song.difficulty} {this.state.random_song.level}
          </div>
          <div className="col-12">
            <button className="btn btn-primary" onClick={this.addRandomSong}>Add Song</button>
          </div>
        </div>
      )
    }
  },

  addRandomSongForm(){
    if(this.state.song_random == true){
      return(
        <div className="form-group">
          <div>
            Min Level:
            <input type="number" className="form-control" id="name" value={this.state.random.min_level} onChange={this.handleMinLevelChange} />
          </div>
          <div>
            Max Level:
            <input type="number" className="form-control" id="name" value={this.state.random.max_level} onChange={this.handleMaxLevelChange}/>
          </div>
          <br/>
          <button className="btn btn-primary" onClick={this.handleGetRandomSong}>Get Song</button>
          <br/>
          {this.randomSongDisplay()}
        </div>
      );
    }
  },

  render: function() {

    callRemoveFunction = this.removeSongFromList;

    qualifier_songs = this.state.qualifiers.map( function(song) {
      return (
        <Qualifier_Songs song={song} key={"song_"+song.id} removeSong={callRemoveFunction} />
      );
    });

    return (
      <div>
        <button className="btn btn-primary" onClick={this.handleAddSongRandomForm}>Add Song (Random)</button>
        &nbsp;
        <button className="btn btn-primary" onClick={this.handleAddSongManualForm}>Add Song (Manual)</button>
        <br/>
        {this.addManualSongForm()}
        {this.addRandomSongForm()}
        <br/>
        <br/>
        <br/>
        <strong>Qualifier Songs:</strong>
          {qualifier_songs}
        <br />
      </div>
    );
  }
});
