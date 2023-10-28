import {Knex} from 'knex';
import {Vendor} from '../../models';

interface VendorsServiceSettings {
  db: Knex;
}

class VendorsService {
  private readonly vendorsTable = 'vendors';

  constructor(private readonly settings: VendorsServiceSettings) {}

  async listVendors(): Promise<Vendor[]> {
    const {db} = this.settings;

    const vendors = await db<Vendor>(this.vendorsTable);

    return vendors;
  }
}

export {VendorsService};
