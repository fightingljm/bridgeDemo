'use strict'
import React from 'react';
import {
    View,
    requireNativeComponent,
    NativeModules
} from 'react-native';
import PropTypes from "prop-types";

var BDMapManager = NativeModules.RCTBDMapManager;

class MapView extends React.Component{
    // static defaultProps = {
    //     ...View.propTypes,
    //     style: View.propTypes.style,
    //     // annotations: PropTypes.arrayOf(PropTypes.shape({
    //     //     /**
    //     //      * The location of the annotation.
    //     //      */
    //     //     latitude: PropTypes.number.isRequired,
    //     //     longitude: PropTypes.number.isRequired,
    //     //     /**
    //     //      * Annotation title and subtile.
    //     //      */
    //     //     title: PropTypes.string,
    //     // })),
    //     pitchEnabled: PropTypes.bool,
    // }
    render() {
        return (<RCTBDMap {...this.props} annotations={this.props.annotations} pitchEnabled={true} />);
    }
}

let RCTBDMap = requireNativeComponent('RCTBDMap', MapView);

export default MapView
