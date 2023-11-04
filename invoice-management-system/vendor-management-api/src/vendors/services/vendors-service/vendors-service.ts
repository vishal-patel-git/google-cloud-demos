import {Knex} from 'knex';
import {Vendor} from '../../models';

interface VendorsServiceOptions {
  db: Knex;
}

class VendorsService {
  private readonly vendorsTable = 'vendors';

  constructor(private readonly options: VendorsServiceOptions) {}

  async createVendor(name: string, address: string): Promise<Vendor> {
    const [vendor] = await this.options
      .db<Vendor>(this.vendorsTable)
      .insert({name, address})
      .returning('*');

    return vendor;
  }

  async getVendor(id: string): Promise<Vendor> {
    const [vendor] = await this.options
      .db<Vendor>(this.vendorsTable)
      .where({id});

    return vendor;
  }

  async deleteVendor(id: string): Promise<void> {
    await this.options.db(this.vendorsTable).where('id', id).del();
  }
}

export {VendorsService};
