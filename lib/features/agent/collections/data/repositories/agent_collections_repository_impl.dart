import 'package:citizenone_app/features/agent/collections/domain/entities/agent_collection_entity.dart';
import 'package:citizenone_app/features/agent/collections/domain/repositories/agent_collections_repository.dart';

class AgentCollectionsRepositoryImpl implements AgentCollectionsRepository {
  @override
  Future<List<AgentCollectionEntity>> getCollections() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockCollections;
  }

  @override
  Future<bool> markCollected(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}

const _mockCollections = [
  AgentCollectionEntity(
    id: 'col_001',
    merchantName: 'Green Grocers Ltd',
    amountDue: 'ZK 12,000',
    dueDate: 'Today',
    status: CollectionStatus.pending,
    location: 'Cairo Road, Lusaka',
    phone: '+260 95 345 6789',
    lastCollectedDate: '01 May 2025',
  ),
  AgentCollectionEntity(
    id: 'col_002',
    merchantName: 'Sunrise Pharmacy',
    amountDue: 'ZK 8,500',
    dueDate: 'Today',
    status: CollectionStatus.pending,
    location: 'Woodlands, Lusaka',
    phone: '+260 96 567 8901',
    lastCollectedDate: '30 Apr 2025',
  ),
  AgentCollectionEntity(
    id: 'col_003',
    merchantName: 'Bwalya Hardware',
    amountDue: 'ZK 22,000',
    dueDate: '3 days ago',
    status: CollectionStatus.overdue,
    location: 'Chilenje, Lusaka',
    phone: '+260 97 456 7890',
    lastCollectedDate: '15 Apr 2025',
  ),
  AgentCollectionEntity(
    id: 'col_004',
    merchantName: 'Phiri Transport',
    amountDue: 'ZK 5,000',
    dueDate: '1 week ago',
    status: CollectionStatus.overdue,
    location: 'Kabwata, Lusaka',
    phone: '+260 97 234 5678',
    lastCollectedDate: '05 Apr 2025',
  ),
  AgentCollectionEntity(
    id: 'col_005',
    merchantName: 'City Boutique',
    amountDue: 'ZK 9,200',
    dueDate: 'Yesterday',
    status: CollectionStatus.collected,
    location: 'Arcades, Lusaka',
    phone: '+260 96 123 4567',
    lastCollectedDate: '14 May 2025',
  ),
];
