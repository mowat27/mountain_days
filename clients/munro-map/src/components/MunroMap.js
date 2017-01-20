import React from 'react'
import { connect } from 'react-redux'
import { Map, GoogleApiWrapper, Marker } from 'google-maps-react'

class MunroMap extends React.Component {
  summitIcon(google, summit) {
    let redPin = 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|FE7569'
    let greenPin = 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|58D68D'

    return {
      url: summit.selected ? greenPin : redPin
    }
  }

  render() {
    if(!this.props.loaded) {
      return <div>Loading...</div>
    }

    return (
      <div className="map-container" style={{width: '100%', height: '80%', position: 'relative'}}>
        <Map
          google={this.props.google}
          initialCenter={{lat: 57.365, lng: -4.9}}
          zoom={8}>
            {
              this.props.summits.map( summit => (
                <Marker key={summit.hillnumber}
                  name={summit.name}
                  position={summit.position}
                  icon={this.summitIcon(this.props.google, summit)}
                /> )
              )
            }
        </Map>
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  let selected = state.selections.selectedHill 
  return {
    summits: state.hills.map( (hill) => ({
      hillnumber: hill.hillnumber,
      name: hill.hillname,
      position: {lat: hill.summit.latitude, lng: hill.summit.longitude},
      selected: parseInt(hill.hillnumber) === selected
    })),
    ...state
  }
}

const WrappedMap = GoogleApiWrapper({
  version: 3.26,
  apiKey: 'AIzaSyDVq4XLYhKGimrVqYGS9ttPPNyJBteFCXo'
})(connect(mapStateToProps)(MunroMap))

export default WrappedMap
