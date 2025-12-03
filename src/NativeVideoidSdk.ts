// src/NativeVideoidSdk.ts
import type {TurboModule} from 'react-native';
import {TurboModuleRegistry} from 'react-native';

export interface BaseConfig {
  endpoint: string;
  authorization: string;
  language?: string;
}

export interface StartVideoIdConfig extends BaseConfig {
  documentID: number;
}

export interface StartVideoScanConfig extends BaseConfig {
  documentID: number;
}

export interface StartSmileIdConfig extends BaseConfig {}

export interface StartCertIdConfig extends BaseConfig {}

export interface VideoIdResult {
  status: 'success' | 'error';
  videoId?: string;
  code?: string;
  message?: string;
  flowType?: 'videoId' | 'videoScan' | 'smileId' | 'certId';
}

export interface Spec extends TurboModule {
  startVideoID(config: StartVideoIdConfig): Promise<VideoIdResult>;
  startVideoId(token: string): Promise<string>;
  startVideoScan(config: StartVideoScanConfig): Promise<VideoIdResult>;
  startSmileID(config: StartSmileIdConfig): Promise<VideoIdResult>;
  startCertID(config: StartCertIdConfig): Promise<VideoIdResult>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('VideoidSdk');
