// src/index.ts

import NativeModule from './NativeVideoidSdk';
import type {
  StartVideoIdConfig,
  StartVideoScanConfig,
  StartSmileIdConfig,
  StartCertIdConfig,
  VideoIdResult,
} from './NativeVideoidSdk';

export function startVideoID(
  config: StartVideoIdConfig,
): Promise<VideoIdResult> {
  return NativeModule.startVideoID(config);
}

export function startVideoScan(
  config: StartVideoScanConfig,
): Promise<VideoIdResult> {
  return NativeModule.startVideoScan(config);
}

export function startSmileID(
  config: StartSmileIdConfig,
): Promise<VideoIdResult> {
  return NativeModule.startSmileID(config);
}

export function startCertID(
  config: StartCertIdConfig,
): Promise<VideoIdResult> {
  return NativeModule.startCertID(config);
}

export type {
  StartVideoIdConfig,
  StartVideoScanConfig,
  StartSmileIdConfig,
  StartCertIdConfig,
  VideoIdResult,
};

export default {
  startVideoID,
  startVideoScan,
  startSmileID,
  startCertID,
};
