var PreQualifiers = React.createClass({
  getInitialState() {
    return {
      qualifiers: this.props.qualifiers || [],
      qualifier:{
        name: '',
        difficulty: '',
        level: ''
      },
      random:{
        song_min: 0,
        song_max: 20
      },
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

  handleAddSong(){
    var that = this;
    $.ajax({
      method: 'POST',
      data: {
        qualifier: this.state.qualifier,
        tournament_id: this.props.tournament_id
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
            level:''
          },
          errors: {},
        });
      },
      error: function(error){
        that.setState({errors: data.responseJSON.errors})
      }
    });
  },

  handleAddSongManual(){
    if(this.state.song_manual == true){
      this.setState({song_manual: false});
    }
    else{
      this.setState({song_manual: true});
      this.setState({song_random: false});
    }
  },

  handleAddSongRandom(){
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
          <button className="btn btn-primary" onClick={this.handleAddSong}>Add Song</button>
        </div>
      );
    }
    else return null;
  },

  addRandomSongForm(){
    if(this.state.song_random == true){
      return(
        <div className="form-group">
          <div>
            Min Level:
            <input type="number" className="form-control" id="name" value={this.state.random.min_level} />
          </div>
          <div>
            Max Level:
            <input type="number" className="form-control" id="name" value={this.state.random.max_level} />
          </div>
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
        <button className="btn btn-primary" onClick={this.handleAddSongRandom}>Add Song (Random)</button>
        &nbsp;
        <button className="btn btn-primary" onClick={this.handleAddSongManual}>Add Song (Manual)</button>
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
