import {Knex} from 'knex';
import {Supplier} from '../../models';

interface SuppliersServiceSettings {
  db: Knex;
}

class SuppliersService {
  private readonly suppliersTable = 'suppliers';

  constructor(private readonly settings: SuppliersServiceSettings) {}

  async listSuppliers(): Promise<Supplier[]> {
    const {db} = this.settings;

    return await db<Supplier>(this.suppliersTable);
  }
}

export {SuppliersService};
