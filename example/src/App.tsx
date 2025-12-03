// example/src/App.tsx

import {Button, Text, View} from 'react-native';
import {SafeAreaView} from 'react-native-safe-area-context';
import VideoIdSDK from 'react-native-videoid-sdk';

import type {
  StartVideoIdConfig,
  StartVideoScanConfig,
  StartSmileIdConfig,
  StartCertIdConfig,
} from 'react-native-videoid-sdk';

export default function App() {
  const base = {
    endpoint: 'https://etrust-sandbox.electronicid.eu/v2/',
    authorization: 'vt2B7_S09y7oYw8E9mklrYVPkDnMHlUz3_0d_u5ICDiTX-E9YxdKBDgsHO6mLuv0paJprWDV-Ubkhrk55bmBk9eg_KumRGIsxxRu2ru6wY8=',
    // authorization: 'elTtYWbP1gINv8ZjhmIHOpblmQ_UYn16Roy-b6IK3tpjZqlXNqBBXNbystgjROKBXHRud5_RH_B8IE7BNIybBTs3TbUfG6RNiSOyc_mBw2M=',
    language: 'en',
  };

  const runVideoID = () => {
    const config: StartVideoIdConfig = {...base, documentID: 62};
    VideoIdSDK.startVideoID(config).then(console.log).catch(console.error);
  };

  const runVideoScan = () => {
    const config: StartVideoScanConfig = {...base, documentID: 62};
    VideoIdSDK.startVideoScan(config).then(console.log).catch(console.error);
  };

  const runSmileID = () => {
    const config: StartSmileIdConfig = {...base};
    VideoIdSDK.startSmileID(config).then(console.log).catch(console.error);
  };

  const runCertID = () => {
    const config: StartCertIdConfig = {...base};
    VideoIdSDK.startCertID(config).then(console.log).catch(console.error);
  };

  return (
    <SafeAreaView style={{flex: 1}}>
      <View
        style={{
          flex: 1,
          justifyContent: 'center',
          alignItems: 'center',
          gap: 14, // spacing between buttons
        }}>
        <Text style={{fontSize: 20, marginBottom: 16}}>
          RN VideoID SDK Package
        </Text>

        <Button title="Start VideoID" onPress={runVideoID} />
        <Button title="Start VideoScan" onPress={runVideoScan} />
        <Button title="Start SmileID" onPress={runSmileID} />
        <Button title="Start CertID" onPress={runCertID} />
      </View>
    </SafeAreaView>
  );
}