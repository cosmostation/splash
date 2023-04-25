package io.cosmostation.splash.model

enum class ConnectType {
    InternalDapp, ExternalDapp, QRWalletConnect, DeepLinkWalletConnect, DeepLinkWalletConnectCommon;

    fun isDapp(): Boolean {
        return this == InternalDapp || this == ExternalDapp
    }
}
