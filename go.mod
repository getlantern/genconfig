module github.com/getlantern/genconfig

go 1.16

require (
	github.com/getlantern/flashlight v0.0.0-20220120195645-6263b0296ba2
	github.com/getlantern/flashlight/20220120 v0.0.0-20220120120707-bd7a62c26092
	github.com/getlantern/fronted v0.0.0-20210806163345-971f7e536246
	github.com/getlantern/golog v0.0.0-20210606115803-bce9f9fe5a5f
	github.com/getlantern/keyman v0.0.0-20210622061955-aa0d47d4932c
	github.com/getlantern/tlsdialer/v3 v3.0.3
	github.com/getlantern/yaml v0.0.0-20190801163808-0c9bb1ebf426
	github.com/refraction-networking/utls v1.0.0
	github.com/stretchr/testify v1.7.0
)

replace github.com/lucas-clemente/quic-go => github.com/getlantern/quic-go v0.0.0-20211103152344-c9ce5bfd4854

replace github.com/refraction-networking/utls => github.com/getlantern/utls v0.0.0-20211116192935-1abdc4b1acab

replace github.com/anacrolix/go-libutp => github.com/getlantern/go-libutp v1.0.3-0.20210202003624-785b5fda134e

// git.apache.org isn't working at the moment, use mirror (should probably switch back once we can)
replace git.apache.org/thrift.git => github.com/apache/thrift v0.0.0-20180902110319-2566ecd5d999

replace github.com/keighl/mandrill => github.com/getlantern/mandrill v0.0.0-20191024010305-7094d8b40358

replace github.com/google/netstack => github.com/getlantern/netstack v0.0.0-20210430190606-84f1a4e5b695

// For https://github.com/crawshaw/sqlite/pull/112 and https://github.com/crawshaw/sqlite/pull/103.
replace crawshaw.io/sqlite => github.com/getlantern/sqlite v0.3.3-0.20210215090556-4f83cf7731f0

replace github.com/eycorsican/go-tun2socks => github.com/getlantern/go-tun2socks v1.16.12-0.20201218023150-b68f09e5ae93

// v0.5.6 has a security issue and using require leaves a reference to it in go.sum
replace github.com/ulikunitz/xz => github.com/ulikunitz/xz v0.5.8

// Include specific versions of flashlight for backward compatibility testing
replace github.com/getlantern/flashlight/20220120 => github.com/getlantern/flashlight v0.0.0-20220120120707-bd7a62c26092
