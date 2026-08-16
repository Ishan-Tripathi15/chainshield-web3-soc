const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SecurityRegistry", function () {
  async function deploy() {
    const [admin, analyst, responder, stranger] = await ethers.getSigners();
    const Registry = await ethers.getContractFactory("SecurityRegistry");
    const registry = await Registry.deploy(admin.address);
    await registry.waitForDeployment();
    await registry.grantAnalyst(analyst.address);
    await registry.grantResponder(responder.address);
    return { registry, admin, analyst, responder, stranger };
  }

  it("registers incidents with an evidence hash", async function () {
    const { registry, analyst } = await deploy();
    const hash = ethers.keccak256(ethers.toUtf8Bytes("forensic-log-001"));
    await expect(registry.connect(analyst).registerIncident("Suspicious transfer", hash, 2))
      .to.emit(registry, "IncidentRegistered");
    const incident = await registry.incidents(0);
    expect(incident.title).to.equal("Suspicious transfer");
    expect(incident.evidenceHash).to.equal(hash);
    expect(incident.status).to.equal(0);
  });

  it("blocks unauthorized incident creation", async function () {
    const { registry, stranger } = await deploy();
    await expect(registry.connect(stranger).registerIncident("Unauthorized attempt", ethers.ZeroHash, 3))
      .to.be.reverted;
  });

  it("allows responders to resolve an incident", async function () {
    const { registry, analyst, responder } = await deploy();
    await registry.connect(analyst).registerIncident("Credential anomaly", ethers.ZeroHash, 1);
    await expect(registry.connect(responder).updateStatus(0, 2))
      .to.emit(registry, "IncidentStatusChanged");
    const incident = await registry.incidents(0);
    expect(incident.status).to.equal(2);
    expect(incident.resolvedAt).to.be.greaterThan(0);
  });
});