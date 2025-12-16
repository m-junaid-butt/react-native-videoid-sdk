// src/index.d.ts
export interface VideoIDParams {
  endpoint: string;
  bearer: string;
  rAuthority: string;
  documentID: number;
  language: string;
  style?: {
    roiLineColor?: string;
    mediaNotificationTextColor?: string;
    linkButtonColor?: string;
    textNotificationColor?: string;
    mediaNotificationFontSize?: number;
  };
}

declare const VideoIDSDK: {
  start: (params: VideoIDParams) => Promise<void>;
  addListener: (
    event: 'onComplete' | 'onError',
    callback: (data: any) => void
  ) => any;

  removeAllListeners: (event: string) => void;
};

export default VideoIDSDK;
