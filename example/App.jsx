// example/App.js
import React from 'react';
import { View, Button, Alert } from 'react-native';
import VideoIDSDK from 'react-native-videoid-sdk';

const App = () => {
  const handleStart = async () => {
    try {
      console.log('Starting VideoID...');
      await VideoIDSDK.start({
        endpoint: 'https://etrust-sandbox.electronicid.eu/v2',
        bearer: 'fbd13b2e-d2fc-4b1d-8704-ee32e8856df9',
        rAuthority: '',
        documentID: 62,
        language: 'en',
      });
      console.log('VideoID started');
    } catch (error) {
      console.error('Error:', error);
      Alert.alert('Error', error.message || 'Failed to start VideoID');
    }
  };

  return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <Button title="Start VideoID" onPress={handleStart} />
    </View>
  );
};

export default App;
