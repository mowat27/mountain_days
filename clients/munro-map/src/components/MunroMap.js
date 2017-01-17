import React from 'react'
import { connect } from 'react-redux'
import {Map, GoogleApiWrapper, Marker} from 'google-maps-react'

class MunroMap extends React.Component {
  render() {
    if(!this.props.loaded) {
      return <div>Loading...</div>
    }

    return (
      <div className="map-container">
        <Map
          google={this.props.google}
          initialCenter={{lat: 57.365, lng: -4.9}}
          zoom={8}>
            {
              this.props.summits.map( summit => <Marker key={summit.hillnumber} name={summit.name} position={summit.position}/> )
            }
          </Map>
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    summits: state.hills.map( (hill) => ({
      hillnumber: hill.hillnumber,
      name: hill.hillname,
      position: {lat: hill.summit.latitude, lng: hill.summit.longitude}
    })),
    ...state
  }
}

const WrappedMap = GoogleApiWrapper({
  version: 3.26,
  apiKey: 'AIzaSyDVq4XLYhKGimrVqYGS9ttPPNyJBteFCXo'
})(connect(mapStateToProps)(MunroMap))

export default WrappedMap
