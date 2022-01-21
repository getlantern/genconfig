package main

import (
	"bytes"
	"testing"
	"text/template"

	config_20220120 "github.com/getlantern/flashlight/20220120/config"
	"github.com/getlantern/yaml"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func Test20220120(t *testing.T) {
	g := &config_20220120.Global{}
	loadCloudYamlTemplate(t, g)

	fos := &config_20220120.ReplicaOptionsRoot{}
	require.NoError(t, g.UnmarshalFeatureOptions(config_20220120.FeatureReplica, fos))

	t.Run("testReplicaByCountry", func(t *testing.T) {
		assert := assert.New(t)
		assert.Contains(fos.ByCountry, "RU")
		assert.NotContains(fos.ByCountry, "AU")
		assert.NotEmpty(fos.ByCountry)
		globalTrackers := fos.Trackers
		assert.NotEmpty(globalTrackers)
		// Check the countries pull in the trackers using the anchor. Just change this if they stop
		// using the same trackers. I really don't want this to break out the gate is all.
		assert.Equal(fos.ByCountry["CN"].Trackers, globalTrackers)
		assert.Equal(fos.ByCountry["RU"].Trackers, globalTrackers)
		assert.Equal(fos.ByCountry["IR"].Trackers, globalTrackers)
	})

	t.Run("testReplicaProxying", func(t *testing.T) {
		assert := assert.New(t)
		numInfohashes := len(fos.ProxyAnnounceTargets)
		// The default is to announce as a proxy.
		assert.True(numInfohashes > 0)
		// The default is not to look for proxies
		assert.Empty(fos.ProxyPeerInfoHashes)
		// Iran looks for peers from the default countries.
		assert.Len(fos.ByCountry["IR"].ProxyPeerInfoHashes, numInfohashes)
	})
}

func loadCloudYamlTemplate(t *testing.T, g interface{}) {
	// turn the template into plain yaml
	var w bytes.Buffer
	// We could write into a pipe, but that requires concurrency and we're old-school in tests.
	require.NoError(t, template.Must(template.New("").Parse(string(cloudYamlTemplate))).Execute(&w, nil))
	require.NoError(t, yaml.Unmarshal(w.Bytes(), g))
}
