import Foundation

// DevOps Pipeline Simulator Data Model

// Enum for Pipeline Status
enum PipelineStatus: String, Codable {
    case success
    case failed
    case inProgress
}

// Enum for Pipeline Stage
enum PipelineStage: String, Codable {
    case build
    case test
    case deploy
}

// Pipeline Stage Model
struct PipelineStageModel: Codable, Identifiable {
    let id = UUID()
    var stage: PipelineStage
    var status: PipelineStatus
    var startTime: Date
    var endTime: Date?
}

// DevOps Pipeline Model
struct DevOpsPipeline: Codable, Identifiable {
    let id = UUID()
    var name: String
    var stages: [PipelineStageModel]
    var startTime: Date
    var endTime: Date?
    var status: PipelineStatus {
        get {
            if let lastStage = stages.last, lastStage.status == .success {
                return .success
            } else if stages.contains(where: { $0.status == .failed }) {
                return .failed
            } else {
                return .inProgress
            }
        }
    }
}

// Simulator Class
class DevOpsPipelineSimulator {
    var pipelines: [DevOpsPipeline] = []
    
    func createPipeline(name: String, stages: [PipelineStage]) -> DevOpsPipeline {
        let pipeline = DevOpsPipeline(name: name, stages: stages.map { PipelineStageModel(stage: $0, status: .inProgress, startTime: Date()) })
        pipelines.append(pipeline)
        return pipeline
    }
    
    func updateStageStatus(pipelineId: UUID, stage: PipelineStage, status: PipelineStatus) {
        if let pipeline = pipelines.first(where: { $0.id == pipelineId }) {
            if let stageModel = pipeline.stages.first(where: { $0.stage == stage }) {
                stageModel.status = status
                stageModel.endTime = Date()
            }
        }
    }
    
    func printPipelineStatus(pipelineId: UUID) {
        if let pipeline = pipelines.first(where: { $0.id == pipelineId }) {
            print("Pipeline \(pipeline.name) Status: \(pipeline.status.rawValue)")
            for stage in pipeline.stages {
                print("  \(stage.stage.rawValue): \(stage.status.rawValue)")
            }
        }
    }
}

// Example Usage
let simulator = DevOpsPipelineSimulator()
let pipeline = simulator.createPipeline(name: "My Pipeline", stages: [.build, .test, .deploy])
simulator.updateStageStatus(pipelineId: pipeline.id, stage: .build, status: .success)
simulator.updateStageStatus(pipelineId: pipeline.id, stage: .test, status: .success)
simulator.updateStageStatus(pipelineId: pipeline.id, stage: .deploy, status: .success)
simulator.printPipelineStatus(pipelineId: pipeline.id)