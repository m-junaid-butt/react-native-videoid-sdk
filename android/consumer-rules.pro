# android/consumer-rules.pro

-keep class eu.electronicid.sdk.modules.api.model.** { *; }
-keep class eu.electronicid.sdk.domain.model.terms.** { *; }
-keep class eu.electronicid.sdk.domain.model.videoid.event.** { *; }
-keep class eu.electronicid.sdk.domain.model.errorreport.** { *; }
-keep class eu.electronicid.sdk.domain.model.scan.** { *; }
-keep class eu.electronicid.sdk.domain.model.Rectangle { *; }
-keep class eu.electronicid.sdk.domain.model.Size { *; }
-keep class eu.electronicid.sdk.h264encoder.X264Encoder { *; }
-keep class eu.electronicid.sdk.yuvutils.YuvUtils { *; }
-keep class eu.electronicid.sdk.videoid.model.** { *; }
-keep class eu.electronicid.sdk.videoid.control.model.** { *; }
-keep class eu.electronicid.sdk.videoid.control.communication.** { *; }
-keep class eu.electronicid.sdk.videoid.adhoc.model.FrameCaptureStart { *; }
-keep class eu.electronicid.sdk.videoid.webrtc.model.* { *; }
-keep class org.webrtc.** { *; }
-keep class eu.electronicid.sdk.discriminator.api.model.Bandwidth { *; }
-keep class eu.electronicid.sdk.domain.model.Protocol { *; }
-keep class eu.electronicid.sdk.domain.model.nfc.NFCTag { *; }

-ignorewarnings
